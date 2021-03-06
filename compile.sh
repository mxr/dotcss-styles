#!/bin/sh

source safe_sed.sh

# Some of these are special
echo "Compiling github.com.css"
./github.sh
echo "Done"

echo "Compiling stackoverflow.com.css"
./stackoverflow.sh
echo "Done"

ids=( "154599" "143026" "160459" )
files=(
    "slack.com.css"
    "calendar.google.com.css"
    "news.ycombinator.com.css"
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
