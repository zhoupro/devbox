#!/bin/bash
sudo apt install -y tigervnc-standalone-server tigervnc-xorg-extension

echo "awesome" > ~/.xsession

vncserver -kill :1
vncserver :1 -geometry 1600x840 -SecurityTypes None -local no --I-KNOW-THIS-IS-INSECURE 
killall vncconfig