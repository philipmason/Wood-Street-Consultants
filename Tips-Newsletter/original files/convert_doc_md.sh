#!/bin/bash

# save input from command line
input=$1

# get filename from input
filename=$(basename -s .docx $input)

# convert word to markdown
pandoc -f docx -t markdown "$input"  -o $filename.md

