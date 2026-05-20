# Technische Spezifikation: MarkDo (Arbeitstitel)
## Leichtgewichtige, Markdown-basierte Menüleisten-Todo-App für macOS

---

## 1. Systemvoraussetzungen & Architektur

* **Mindest-Betriebssystem:** macOS Big Sur 11.7.11 (und neuer).
* **Unterstützte Plattformen:** Intel & Apple Silicon (Universal Binary).
* **UI-Framework:** **AppKit (Cocoa)**.
  * *Begründung:* Gewährleistet native Performance unter macOS 11, ausgereiftes Drag & Drop über `NSOutlineView` und fehlerfreie Abwärtskompatibilität ohne die Einschränkungen von SwiftUI 2.0 (Big Sur).
* **Anzeige-Modus:** Reine **Menüleisten-App** (`NSStatusItem`). Kein Dock-Icon, kein Standard-Fenster. Das Hauptfenster wird als Popover direkt an das Menüleisten-Icon geheftet.

---

## 2. Datenmodell & Markdown-Spezifikation (Parsing-Regeln)

Die App arbeitet direkt auf einer vom Nutzer gewählten `.md`-Datei. Die Datei erlaubt optional einen Dateikopf (Titel mit `#` oder YAML-Frontmatter), der vom Parser ignoriert und beim Speichern unverändert gelassen wird.

### 2.1 Element-Typen und Hierarchie

Die App unterscheidet strikt zwei Ebenen von Tasks und ordnet Kommentare anhand ihrer Einrückung zu:

| Ebene | Syntax | Darstellung in der UI | Verhalten |
| :--- | :--- | :--- | :--- |
| **Gruppe** | `## Gruppenname` | Sektions-Überschrift | Container für Tasks |
| **Task (Ebene 1)** | `- [ ] Text` oder `- [x] Text` | Haupt-Aufgabe (Hauptzeile) | Kann Sub-Tasks & Kommentare halten |
| **Sub-Task (Ebene 2)** | `  - [ ] Text` oder `  - [x] Text` | Unter-Aufgabe (Eingerückt) | Kann Kommentare halten |
| **Kommentar** | `[Einrückung] - Text` | Notiz/Zusatztext zu einem Task | Reiner Text (keine Checkbox) |

### 2.2 Striktes Einrückungs-Gesetz & Parsing-Logik

1. **Normalisierung:** Der Parser konvertiert vor der Analyse alle Tabs in eine feste Anzahl von Leerzeichen (z. B. 1 Tab = 4 Leerzeichen) oder normalisiert auf 2 Leerzeichen pro Ebene, um fehlerfreies Parsing zu garantieren.
2. **Einrückung als Zuordnungskriterium:** Die Ebene der Einrückung entscheidet strikt über die strukturelle Zuordnung.
   * Ein Kommentar auf Ebene 2 (eingerückt) unter einem Sub-Task (ebenfalls Ebene 2) gehört strukturell zum übergeordneten **Parent-Task (Ebene 1)**, nicht zum Sub-Task.
3. **Capping bei zu tiefer Einrückung:** Wenn ein Kommentar tiefer eingerückt ist als die erlaubten Task-Ebenen (z. B. Ebene 3 oder tiefer), wird er automatisch der tiefstmöglichen erlaubten Ebene zugeordnet (Capping bei Ebene 2 / Sub-Task).
4. **Sonderfall: Vorauslaufender Kommentar (Gruppen-Beschreibung):** Steht ein Kommentar auf Ebene 1 ganz am Anfang einer Gruppe, noch bevor ein Task definiert wurde, wird er als statischer Textblock direkt unter der Gruppenüberschrift (Gruppen-Beschreibung) angezeigt. Er ist nicht per Drag & Drop verschiebbar.
5. **Strikte Typentrennung:** Aus einem Kommentar kann per UI kein Task werden und umgekehrt. Es gibt keinen Checkbox-Wechsel für Kommentare.
6. **Erledigte Aufgaben:** Werden in der Datei als `- [x]` gespeichert und verbleiben an ihrer exakten Position in der Datei.

---

## 3. Kernfunktionen

### 3.1 Datei-Überwachung (File Watcher)
* Die App nutzt `DispatchSourceFileSystemObject` oder die *File System Events API*, um die ausgewählte `.md`-Datei im Hintergrund zu überwachen.
* Wird die Datei extern (z. B. via Obsidian, VS Code oder iCloud-Synchronisation) geändert, lädt die App die Datei im Hintergrund neu und aktualisiert die UI geräuschlos, ohne den Fokus oder die aktuelle Scroll-Position des Nutzers zu stören.

### 3.2 Minimal-Invasives Drag & Drop (Dateiebene)
* Beim Verschieben von Elementen in der UI wird nicht die gesamte Datei blind neu geschrieben.
* Die App berechnet die Zeilen-Verschiebung (inklusive aller zugehörigen Sub-Tasks und Kommentare des verschobenen Objekts) und tauscht gezielt die Zeilenblöcke in der Datei aus. Dies minimiert Konflikte bei parallelen externen Schreibzugriffen.
* Wenn ein übergeordneter Task verschoben wird, wandern alle seine Sub-Tasks und zugeordneten Kommentare im Block mit.

### 3.3 Globaler Hotkey & Quick Entry
* Ein systemweiter, frei konfigurierbarer Hotkey (Default: `Option + Leertaste`) öffnet ein kleines, zentriertes Eingabefenster (Spotlight-Style).
* **Verhalten:** Nach der Eingabe und dem Drücken von `Enter` schließt sich das Fenster sofort wieder.
* **Zielort:** Das neue Todo wird als offener Task (`- [ ]`) in die Gruppe `## Inbox` ganz oben in der Datei geschrieben.
* **On-Demand Inbox:** Existiert die Gruppe `## Inbox` noch nicht in der Datei, legt die App diese automatisch am Anfang der Datei (unterhalb eines eventuellen Frontmatters/Titels) an, sobald das erste Quick-Entry-Todo erfasst wird.

---

## 4. UI/UX Design & Komponenten

### 4.1 Menüleisten-Popover
Klickt der Nutzer auf das Icon in der Menüleiste, öffnet sich ein Popover, das die Gruppen und Todos in einer hierarchischen Liste darstellt.

* **UI-Komponente:** Realisiert über ein natives `NSOutlineView` innerhalb eines `NSPopover`.
* **Drag & Drop im Popover:**
  * **Interaktivität:** Die Liste unterstützt vollwertiges Drag & Drop zum Sortieren von Tasks innerhalb einer Gruppe oder zwischen Gruppen.
  * **Popover-Schutz (Pinning):** Für den Zeitraum, in dem eine Drag-Operation aktiv ist, wird das automatische Schließen des Popovers (*Transient Behavior*) blockiert, um ein versehentliches Schließen bei Mausbewegungen außerhalb des Fensters zu verhindern.
  * **Visuelles Feedback:** Gruppen können nur untereinander verschoben werden. Tasks zeigen beim Ziehen an, ob sie zwischen zwei Zeilen landen oder in eine andere Gruppe hineingeschoben werden (die Zielgruppe wird visuell hervorgehoben).

### 4.2 Schematische UI-Vorschau
```
+-----------------------------------+
|  [⚙️] MarkDo                       |
+-----------------------------------+
| ## Inbox                          |
|   [ ] Neuer Quick-Entry Task      |
|                                   |
| ## Projekt Alpha                  |
|   [ ] Hauptaufgabe 1              |
|       [ ] Unteraufgabe A          |
|       - Notiz zur Unteraufgabe    |
|     - Notiz zur Hauptaufgabe 1    |
|   [x] Abgehakte Aufgabe           |
+-----------------------------------+
```

---
*Ende der Spezifikation.*
