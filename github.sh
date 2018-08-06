#!/bin/sh

# Creates a github.com.css file from github-dark.css, github-wide.css, and gist-wide.css

source safe_sed.sh

file=github.com.css
url=https://raw.githubusercontent.com/StylishThemes/GitHub-Dark/master/github-dark.css

curl -s "$url" -o "$file"

# This is kind of a hack, allow code blocks to scroll
safe_sed "s=.*nowrap=/**=" "$file"

# Set my background image of choice
safe_sed -E "s/\/\*\[\[bg-choice\]\].*$/none;/" "$file"

# Remove the moz annotations
safe_sed "/moz-document/d" "$file"
safe_sed "$ d" "$file"

# Concatenate additional styles
additional_styles=( "github-wide.css" "gist-wide.css" )
for style in ${additional_styles[@]}
do
  wget -q -N "https://raw.githubusercontent.com/mdo/github-wide/master/$style"
  echo "\n/* $style starts here */\n" >> "$file"
  cat "$style" >> "$file"
  echo "\n/* $style ends here */\n" >> "$file"
done
