#!/usr/bin/env bash
set -euxo pipefail

function cleanup() {
    curl -X POST -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${SLACK_TOKEN}" \
        -d '{"profile": {"status_emoji": "", "status_text": ""}}' \
        -so /dev/null \
        "https://slack.com/api/users.profile.set"
}

trap cleanup EXIT

# use GNU date on Mac OS
if [[ $(uname -s) =~ "Darwin" ]]; then
    date="/usr/local/bin/gdate"
else
    date="date"
fi

curl -X POST -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${SLACK_TOKEN}" \
    -d '{"profile": {"status_emoji": ":tomato:", "status_text": "Pomodoro → '$(echo $(${date} -d "+25 minutes" +%l:%M%P))'"}}' \
    -so /dev/null \
    "https://slack.com/api/users.profile.set"

curl -X GET -H "Authorization: Bearer ${SLACK_TOKEN}" \
    -so /dev/null \
    "https://slack.com/api/dnd.setSnooze?num_minutes=25"

sleep 1500
