#!/bin/bash

export a=$(find /vagrant_data/jjk -name '*.mp3' | fzf --history=/tmp/vlcfzf.txt --query "$(tail -n 1 /tmp/vlcfzf.txt)" )

if [ "$a" == "" ];then
    echo "You don't select...."
    exit 5
fi
echo $a > /tmp/vlcnow.txt

