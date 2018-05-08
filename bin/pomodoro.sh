#!/usr/bin/env bash
set -euo pipefail

# source Slack token
source ~/.secrets
date="/usr/local/bin/gdate"

curl -X POST -H "Content-Type: application/json" \
	-H "Authorization: Bearer ${SLACK_TOKEN}" \
	-d '{"profile": {"status_emoji": ":tomato:", "status_text": "Pomodoro → '$(echo $(${date} -d "+25 minutes" +%l:%M%P))'"}}' \
	-so /dev/null \
	"https://slack.com/api/users.profile.set"

curl -X GET -H "Authorization: Bearer ${SLACK_TOKEN}" \
	-so /dev/null \
	"https://slack.com/api/dnd.setSnooze?num_minutes=25"

sleep 1500

curl -X POST -H "Content-Type: application/json" \
	-H "Authorization: Bearer ${SLACK_TOKEN}" \
	-d '{"profile": {"status_emoji": "", "status_text": ""}}' \
	-so /dev/null \
	"https://slack.com/api/users.profile.set"
