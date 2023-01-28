#!/bin/bash
mkdir -p /vagrant_data/background/horizal
cd  /vagrant_data/background/horizal
curl -s -L https://cn.bing.com/\?ensearch\=1\&FORM\=BEHPTB |grep -o "th?id=[^&\]*jpg"  | uniq | grep "1080" | xargs -n 1 echo '"https://www.bing.com/' | sed -e 's# ##g' -e 's#=#={#g' -e 's#$#}"#g' | head -n 1 | xargs -n 1 curl -s -o "#1"



mkdir -p /vagrant_data/background/vertical
cd  /vagrant_data/background/vertical
curl -L -s https://wallpaperscraft.com/all/1080x1920 | grep "wallpapers__image" | grep -o "h.*.jpg" | sed 's/168x300/1080x1920/g' | head -n 1 | xargs -n 1 curl -s -O

