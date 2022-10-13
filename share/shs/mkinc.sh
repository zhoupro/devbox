#!/bin/bash

fileName=$1
cp $fileName "_pre-$fileName.md"
newName="_pre-$fileName.md"

while IFS= read -r line
do
    file=$(echo "$line" | awk '{print $3}'|xargs echo -n)
    cmd="sed -i -e '/inc *$file/r ./$file' $newName"
    eval $cmd
done <<< $(cat $newName | grep -E '<!-- inc *.* *-->' )