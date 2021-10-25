#!/bin/bash
a=$(cat /usr/share/dict/american-english | fzf )

if [ "$a" == "" ];then
    echo "You don't select...."
    exit 5
fi

goldendict - "$a" 

