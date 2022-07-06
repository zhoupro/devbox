#!/bin/bash

SRC="/tmp/ocr/src"
mkdir -p $SRC

if  [ ! -f /usr/bin/tesseract ];then
    sudo apt install -y xclip tesseract-ocr-eng tesseract-ocr-chi-sim gnome-screenshot imagemagick
fi

sudo gnome-screenshot -a -f $SRC.png  &>/dev/null
sudo mogrify -modulate 100,0 -resize 400% $SRC.png
sudo tesseract $SRC.png $SRC -l  eng &>/dev/null
cat $SRC.txt | xclip -selection clipboard
