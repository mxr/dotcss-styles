#!/bin/sh

source safe_sed.sh

so_file=stackoverflow.com.css

curl -s https://raw.githubusercontent.com/StylishThemes/StackOverflow-Dark/master/stackoverflow-dark.user.css -o "$so_file"

# Only pull out the stack-overflow portion (first moz annotation)
python -c """
from tinycss2 import parse_stylesheet
with open('stackoverflow.com.css', 'r+') as f:
    ss = parse_stylesheet(f.read())
    f.seek(0)
    # Strip moz annotation and last brace
    f.write(ss[2].serialize()[294:-1])
    f.truncate()
"""

# Normalize file
dos2unix "$so_file" > /dev/null 2>&1
safe_sed 's/[[:blank:]]*$//' "$so_file"
