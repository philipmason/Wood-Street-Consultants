#!/bin/bash

# save current working directory to variable
cwd=$(pwd)

# find all .docx files in current directory
find $cwd -name "*.docx" -type f -print0 | while IFS= read -r -d $'\0' line; do

    # remove spaces in filename
    ns_filename=$(echo $line | sed 's/ /_/g')

    # get filename from input
    the_filename=$(basename -s .docx $ns_filename)

    # convert word to markdown
    # echo "pandoc -f docx -t markdown \"$line\" -o $the_filename.md"
    pandoc -f docx -t markdown "$line" -o $the_filename.md
done

