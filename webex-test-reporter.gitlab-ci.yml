stages:
  - test
  - notify

variables:
  # Hier kannst du weitere globale Variablen setzen, z. B. für deine Tests

system_test:
  stage: test
  # Hier kannst du dein gewünschtes Image eintragen (z. B. node, python, ubuntu etc.)
  # image: node:20   # Beispiel
  script:
    - echo "🚀 Starte Systemtests auf Branch ${CI_COMMIT_REF_NAME}..."
    - echo "Commit: ${CI_COMMIT_SHORT_SHA} – ${CI_COMMIT_TITLE}"
    # <<< HIER DEINE ECHTEN SYSTEMTESTS EINFÜGEN >>>
    # Beispiel:
    # - npm ci
    # - npm run system-test || exit 1
    # Oder: ./run-system-tests.sh
  after_script:
    - |
      if [ "$CI_JOB_STATUS" = "success" ]; then
        echo "TEST_RESULT=✅ Erfolgreich" > test-result.env
        echo "TEST_EMOJI=🟢" >> test-result.env
      else
        echo "TEST_RESULT=❌ Fehlgeschlagen" > test-result.env
        echo "TEST_EMOJI=🔴" >> test-result.env
      fi
  artifacts:
    reports:
      dotenv: test-result.env   # übergibt TEST_RESULT + TEST_EMOJI an den nächsten Job

notify_webex:
  stage: notify
  image: alpine:latest
  when: always                  # läuft immer, auch bei Test-Fehler
  needs: ["system_test"]
  script:
    - apk add --no-cache curl jq > /dev/null 2>&1

    - |
      echo "📡 Berechne Success-Streak und sende Webex-Nachricht..."

      # Pipeline-Historie abrufen (neueste zuerst)
      PIPELINES=$(curl -s \
        --header "PRIVATE-TOKEN: $CI_JOB_TOKEN" \
        "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/pipelines?ref=${CI_COMMIT_REF_NAME}&per_page=50&order_by=created_at&sort=desc")

      # Vorherige aufeinanderfolgende Successful-Pipelines zählen
      # (nur abgeschlossene Pipelines, aktuelle Pipeline wird ignoriert)
      PREV_STREAK=$(echo "$PIPELINES" | jq -r '
        [ .[] 
          | select(.id != '"${CI_PIPELINE_ID}"')
          | select(.status | IN("success", "failed", "canceled", "skipped"))
          | .status 
        ] 
        | [range(length) as $i | if .[$i] != "success" then $i else empty end][0] // length
      ')

      # Aktuellen Streak berechnen
      if [ "$TEST_RESULT" = "✅ Erfolgreich" ]; then
        STREAK=$((PREV_STREAK + 1))
        STREAK_TEXT="🔥 **${STREAK}** aufeinanderfolgende Erfolge!"
      else
        STREAK=0
        STREAK_TEXT="Streak zurückgesetzt."
      fi

      # Schöne Markdown-Nachricht für Webex
      MESSAGE="${TEST_EMOJI} **Systemtest** auf \`${CI_COMMIT_REF_NAME}\`  \n"
      MESSAGE+="**${TEST_RESULT}**  \n\n"
      MESSAGE+="📌 Commit: \`${CI_COMMIT_SHORT_SHA}\` – ${CI_COMMIT_TITLE}  \n"
      MESSAGE+="🔗 [Pipeline ansehen](${CI_PIPELINE_URL})  \n"
      MESSAGE+="⏰ ${CI_JOB_STARTED_AT}  \n"
      MESSAGE+="\n${STREAK_TEXT}"

      # Nachricht an Webex Bot senden
      curl -X POST https://webexapis.com/v1/messages \
        -H "Authorization: Bearer ${WEBEX_BOT_TOKEN}" \
        -H "Content-Type: application/json" \
        -d "{
          \"roomId\": \"${WEBEX_ROOM_ID}\",
          \"markdown\": \"${MESSAGE}\"
        }"

    - echo "✅ Webex-Nachricht erfolgreich gesendet!"
