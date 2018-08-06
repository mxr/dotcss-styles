#!/bin/sh

source safe_sed.sh

# GitHub is special
echo "Compiling github.com.css"
./github.sh
echo "Done"

ids=( "154599" "143026" "136189" "160459" "35345")
files=(
    "slack.com.css"
    "calendar.google.com.css"
    "inbox.google.com.css"
    "news.ycombinator.com.css"
    "stackoverflow.com.css"
)

for ((i=0; i<${#ids[@]}; ++i))
do
    id="${ids[i]}"
    file="${files[i]}"

    echo "Compiling $file"

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

    # Normalize files
    dos2unix "$file" > /dev/null 2>&1
    safe_sed 's/[[:blank:]]*$//' "$file"

    echo "Done"
done


echo "Post-processing inbox.google.com.css"
# Fix sender name color
vim --clean  +'execute "normal /fX\<CR>jwi !important"' +'x' inbox.google.com.css
echo "Done"
