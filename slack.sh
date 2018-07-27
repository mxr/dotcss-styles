#!/bin/sh

source safe_sed.sh

file=slack.com.css

# Download the file
curl \
    -s 'https://userstyles.org/api/v1/styles/154599' \
    -H 'referer: https://userstyles.org/styles/154599/slack-tomorrow-dark-slate' \
    --compressed \
    | jq -r '.css' > "$file"

# Remove the moz annotations
safe_sed "/moz-document/d" "$file"
safe_sed "$ d" "$file"
