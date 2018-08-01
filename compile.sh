#!/bin/sh

source safe_sed.sh
source github.sh

# GitHub is special
./github.sh

ids=( "154599" "143026" "136189" )
files=( "slack.com.css" "calendar.google.com.css" "inbox.google.com.css" )

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

    # Remove everything up to and including the first brace (moz annotation)
    vim --clean -u NONE +'execute "normal V/{/e+1\<CR>d"' +'x' "$file"
    # Remove last brace
    safe_sed "$ d" "$file"
done
