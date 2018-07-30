#!/bin/sh

source safe_sed.sh
source github.sh

# GitHub is special
./github.sh

ids=( "154599" "143026" )
files=( "slack.com.css" "calendar.google.com.css" )

for ((i=0; i<${#ids[@]}; ++i))
do
    id="${ids[i]}"
    file="${files[i]}"

    # Download the file
    curl \
        -s "https://userstyles.org/api/v1/styles/$id" \
        -H "referer: https://userstyles.org/styles/$id" \
        --compressed \
        | jq -r '.css' > "$file"

    # Remove the moz annotations
    safe_sed "/moz-document/d" "$file"
    safe_sed "$ d" "$file"
done
