#!/usr/bin/env bash

# change to git root if not there
cd "$(git rev-parse --show-toplevel)" || return

ARGV=("$@")
COLORS=("" "26367" "16750848" "65433" "10027263")

MAT_ID="${ARGV[0]}"
PR_NUM="${ARGV[1]}"
PR_URL="${ARGV[2]}"
COLOR=${COLORS[MAT_ID]}
TITLE=$(bash .github/utils/title.sh)
ABS=$(bash .github/utils/mla.sh)

# https://birdie0.github.io/discord-webhooks-guide/discord_webhook.html
JSON="[{
  \"url\": \"$PR_URL\",
  \"color\": \"$COLOR\",
  \"title\": \"($MAT_ID) $TITLE\",
  \"description\" : \"$ABS [Merge PR $PR_NUM]($PR_URL)\" }]"

JSON=${JSON//$'\n'/}
echo "${JSON//\"/\\\"}"
