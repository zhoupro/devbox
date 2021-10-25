#!/bin/bash

export a=$(find /vagrant_data/jjk -name '*.mp3' | fzf )

if [ "$a" == "" ];then
    echo "You don't select...."
    exit 5
fi


(nohup vlc "$a"  & ) || vlc "$a" && exit 0 
