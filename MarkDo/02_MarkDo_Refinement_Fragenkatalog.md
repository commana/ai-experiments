# MarkDo – Refinement Workshop
## Fragenkatalog offener Punkte & Klärungsbedarfe

**Version:** 1.0  
**Datum:** 20. Mai 2026  
**Basierend auf:** Technische Spezifikation „MarkDo“ (Menüleisten-Todo-App für macOS)  
**Zielgruppe:** Product Owner, Entwickler:innen, UX  
**Zweck:** Strukturierte und priorisierte Klärung aller offenen Punkte vor der detaillierten Planung und Implementierung

---

## Einleitung

Die Spezifikation ist bereits sehr gut durchdacht und zeigt ein klares Verständnis für die Zielgruppe sowie die technischen Herausforderungen einer nativen macOS-Menüleisten-App.  

Dennoch wurden bei der Review mehrere **Ambiguitäten**, **fehlende Details** und **implizite Annahmen** identifiziert. Dieser Fragenkatalog dient als Arbeitsgrundlage für den Workshop, um ein gemeinsames Verständnis zu schaffen und ein robustes Lastenheft / Product Backlog ableiten zu können.

---

## 1. Produktvision & Gesamt-Scope

1. **Zentrale Ausrichtungsfrage**  
   Soll MarkDo primär ein **schneller Viewer + Quick-Entry-Tool** für eine manuell (extern) gepflegte Markdown-Datei sein, oder ein **vollwertiger (wenn auch minimalistischer) Task-Manager**, der umfassende Bearbeitung direkt im Popover ermöglicht?

2. Wie stark soll die App den Fokus auf **Interoperabilität mit bestehenden Markdown-Tools** (Obsidian, VS Code, iA Writer etc.) legen versus eigenständiger Funktionalität?

3. Gibt es eine klare Vision für den **Scope der ersten Version** (MVP)? Welche der in diesem Katalog genannten Funktionen sind „Must-have“ für den Launch?

4. Soll die App langfristig auch **mehrere Markdown-Dateien** unterstützen oder bleibt es bei einer zentralen Datei?

---

## 2. Datenmodell & Markdown-Parsing

### 2.1 Syntax & Erkennung

5. Wie genau wird ein **Kommentar** syntaktisch erkannt?  
   - Muss er zwingend mit `- ` beginnen (ohne `[ ]` / `[x]`)?  
   - Sind auch reine eingerückte Textzeilen ohne Bullet erlaubt?

6. Die Regel „Ein Kommentar auf Ebene 2 unter einem Sub-Task gehört strukturell immer zum übergeordneten Parent-Task (Ebene 1)“ – bitte mit **2–3 konkreten Beispielen** (gute und schlechte Fälle) erläutern.

7. Dürfen Sub-Tasks eigene Kommentare besitzen, oder ist die Intention, dass **alle Kommentare** immer nur an Ebene-1-Tasks hängen?

### 2.2 Parsing-Verhalten & Edge-Cases

8. Wie soll mit **Tabs vs. Leerzeichen** umgegangen werden? Welche Normalisierungsregel gilt genau (z. B. 1 Tab = 4 Leerzeichen oder strikt 2 Leerzeichen pro Ebene)?

9. Wie werden **andere Markdown-Elemente** behandelt (normale Bullet-Listen, nummerierte Listen, Tabellen, Code-Blöcke, Überschriften tieferer Ebenen, horizontale Linien etc.)?

10. Wie wird **YAML-Frontmatter** erkannt und unverändert gelassen? Welche Varianten sollen unterstützt werden?

11. Sollen **leere Zeilen** und die originale Formatierung so weit wie möglich erhalten bleiben, oder darf der Parser/serialisierte Output neu formatieren?

12. Welche **Edge-Cases** müssen zwingend mit Testdateien abgedeckt werden? (z. B. Kommentar vor erstem Task, sehr tiefe Einrückung, Task direkt nach Frontmatter, gemischte Hierarchien)

---

## 3. Benutzeroberfläche & Interaktion (Popover)

### 3.1 CRUD-Operationen

13. **Kernfrage zur Editierbarkeit**  
    Wie werden neue Tasks, Sub-Tasks und Kommentare **im Popover angelegt**, Texte bearbeitet und Elemente gelöscht?  
    (Kontextmenü, „+“-Button, Inline-Editing, Tastaturkürzel, oder bewusst nur über externen Editor + File Watcher?)

14. Gibt es eine Möglichkeit, **Kommentare direkt im Popover** hinzuzufügen oder zu bearbeiten, oder sind sie rein lesend?

### 3.2 Drag & Drop

15. Unterstützt Drag & Drop das **Ändern der Hierarchie**?  
    - Kann ein Haupt-Task zu einem Sub-Task eines anderen Tasks werden (Re-Parenting)?  
    - Kann ein Sub-Task zu einem Haupt-Task „promoted“ werden?

16. Welches visuelle Feedback soll beim Ziehen von Tasks angezeigt werden („wird Sub-Task“, „wird Geschwister“, Zielgruppe hervorheben etc.)?

17. Dürfen **Gruppen** per Drag & Drop untereinander verschoben werden (Reihenfolge ändern)? Oder nur Tasks?

### 3.3 Weitere UI-Details

18. Wie soll mit **erledigten Tasks** umgegangen werden?  
    - Immer sichtbar an ihrer Position bleiben?  
    - Ausblendbar?  
    - Automatisch ans Ende der Gruppe verschieben?

19. Welche weiteren Interaktionen sind im Popover geplant? (Suche/Filter, Tastatur-Navigation, Multi-Select etc.)

20. Menüleisten-Icon:  
    - Eigenes Icon oder System-Standard?  
    - Dynamisches Badge mit Anzahl offener Tasks gewünscht?

21. Popover:  
    - Feste oder dynamische Größe?  
    - Maximale Höhe / Scroll-Verhalten bei sehr vielen Einträgen?

---

## 4. Dateimanagement & Synchronisation

22. **Initial Setup**  
    Wie wählt der User beim ersten Start die Markdown-Datei aus? Gibt es einen Datei-Auswahldialog oder ein Onboarding?

23. Wo wird der Dateipfad persistent gespeichert (UserDefaults, App Support etc.)?

24. **Fehlerzustände**  
    Was passiert, wenn die ausgewählte Datei gelöscht, verschoben oder nicht mehr lesbar/schreibbar ist?

25. **Konkurrierende Zugriffe (Conflict Handling)**  
    Wie soll bei gleichzeitiger Bearbeitung durch MarkDo und einen externen Editor (Obsidian, VS Code, iCloud) vorgegangen werden?  
    (Last-Writer-Wins, automatischer Reload mit Notification, manuelle Merge-UI?)

26. Werden Datei-Änderungen **atomar** geschrieben? Gibt es ein automatisches Backup vor größeren Operationen (z. B. vor Drag & Drop von großen Blöcken)?

27. Wie reagiert der File Watcher auf `rename`, `move` oder `delete` der Datei (nicht nur Content-Change)?

---

## 5. Konfiguration, Hotkeys & App-Lifecycle

28. **Einstellungen / Preferences**  
    Welche Optionen soll der User konfigurieren können? (Beispiele: Hotkey, Dateipfad, Standardgruppe für Quick Entry, Verhalten erledigter Tasks, Einrückungstiefe)

29. Quick Entry:  
    Soll das neue Todo **immer** in die Gruppe `## Inbox` geschrieben werden, oder soll perspektivisch auch die Möglichkeit bestehen, es einer anderen Gruppe zuzuordnen?

30. Globaler Hotkey:  
    - Wie soll die Konfiguration des Hotkeys erfolgen?  
    - Welche API wird für die Registrierung verwendet?

31. **App-Lifecycle**  
    - Soll die App automatisch beim Login starten?  
    - Wie verhält sich die App beim Schließen des Popovers (bleibt sie aktiv im Hintergrund)?

32. Gibt es einen „Quit“-Menüeintrag oder versteckt sich die App komplett in der Menüleiste?

---

## 6. Nicht-funktionale Anforderungen

33. **Performance**  
    Welche Zielwerte gelten für Dateigröße und Antwortzeiten? (z. B. „Dateien bis 10.000 Zeilen sollen in unter 200 ms neu geladen werden“)

34. **Undo / Redo**  
    Wie tief soll die Undo-Funktionalität gehen? (Nur letzte Aktion? Mehrere Schritte? Auch nach externen Änderungen?)

35. **Barrierefreiheit**  
    Welcher Grad an Accessibility-Unterstützung wird erwartet? (VoiceOver, volle Tastaturbedienung, reduzierte Animationen)

36. **Fehlerbehandlung & User Feedback**  
    Wie sollen Parsing-Fehler, Schreibfehler oder Synchronisationskonflikte dem Nutzer kommuniziert werden?

37. **Distribution & Sicherheit**  
    - Wird die App für den Mac App Store oder als direkter Download entwickelt?  
    - Welche Anforderungen bestehen bezüglich Sandboxing und Hardened Runtime?

38. **Internationalisierung**  
    Soll die App mehrsprachig (mindestens Deutsch + Englisch) sein?

---

## 7. Weitere offene Punkte & Annahmen

39. Welche **weiteren Features** sind für spätere Versionen angedacht, die bereits jetzt berücksichtigt werden sollten? (z. B. Statistiken, Tags, Fälligkeitsdaten, Integration mit Calendar/Reminders)

40. Gibt es explizite **Nicht-Ziele** (Out of Scope) für die erste Version?

41. Welche **Annahmen** treffen wir aktuell stillschweigend, die im Workshop explizit gemacht werden sollten?

---

## Anhang: Empfohlene nächste Schritte

Nach Klärung der obigen Fragen wird empfohlen:

1. Erstellung von **3–5 repräsentativen Beispiel-Markdown-Dateien** (inkl. Edge-Cases) als verbindliche Testgrundlage für den Parser.
2. Ergänzung der Spezifikation um konkrete **User Stories** mit Akzeptanzkriterien.
3. Erstellung von **Wireframes / Interaktionsskizzen** für:
   - Popover (inkl. Drag & Drop States)
   - Quick-Entry-Fenster
   - Preferences-Fenster (falls gewünscht)
4. Definition von **nicht-funktionalen Anforderungen** (Performance, Reliability, Accessibility).
5. Erstellung eines ersten **Technical Spikes** für das Parsing-Modul und den File Watcher.

---

**Hinweis für den Workshop:**  
Bitte die Fragen nach Relevanz und Dringlichkeit priorisieren. Offene Punkte aus Abschnitt 2 (Datenmodell) und 3 (UI/Interaktion) haben besonders hohe Abhängigkeit für die technische Umsetzung.

---

*Erstellt mit Unterstützung durch Senior Requirements Engineering Review*