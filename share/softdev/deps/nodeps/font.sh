# font
if [ ! -f /usr/share/fonts/jetfont.ttf ];then
     cp  /vagrant_data/jetfont.ttf   /usr/share/fonts/jetfont.ttf
     fc-cache -f -v
fi