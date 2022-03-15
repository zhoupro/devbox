#!/bin/bash
cd  /vagrant_data/background/horizal
curl -L https://cn.bing.com/\?ensearch\=1\&FORM\=BEHPTB |grep -o "th?id=[^&\]*jpg"  | uniq | grep "1080" | xargs -n 1 echo '"https://www.bing.com/' | sed -e 's# ##g' -e 's#=#={#g' -e 's#$#}"#g' | xargs -n 1 curl -o "#1"
