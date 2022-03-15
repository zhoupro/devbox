#!/bin/bash
a=$(find /vagrant_data/books -name '*.pdf' | fzf )

if [ "$a" == "" ];then
    echo "You don't select...."
    exit 5
fi

zathura --fork "$a"

