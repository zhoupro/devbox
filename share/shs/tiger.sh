#!/bin/bash

#echo "awesome" > ~/.xsession
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

#vncserver :1 -geometry 1600x1200 -SecurityTypes None -local no --I-KNOW-THIS-IS-INSECURE 

#tigervncserver -xstartup /usr/bin/awesome -geometry 800x600 -localhost no :3 -SecurityTypes none --I-KNOW-THIS-IS-INSECURE
tigervncserver -kill :2
tigervncserver -xstartup /usr/bin/xfce4-session  -localhost no :2 -SecurityTypes none --I-KNOW-THIS-IS-INSECURE
tigervncserver -kill :3
tigervncserver -xstartup /usr/bin/awesome  -localhost no :3 -SecurityTypes none --I-KNOW-THIS-IS-INSECURE

#killall vncconfig