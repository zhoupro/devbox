#!/bin/bash

echo "awesome" > ~/.xsession
#echo "gnome" > ~/.xsession


export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="zh_CN.utf8"
export LC_COLLATE="zh_CN.utf8"

export INPUT_METHOD=fcitx
export XIM=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

export LIBGL_ALWAYS_SOFTWARE=1
vncserver -kill :1
vncserver :1 -geometry 1600x1200 -SecurityTypes None -local no --I-KNOW-THIS-IS-INSECURE 
killall vncconfig