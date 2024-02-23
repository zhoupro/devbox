#!/bin/bash

curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin


export PATH=$PATH:/home/vagrant/.local/kitty.app/bin

export GLFW_IM_MODULE=ibus  to /etc/profile

[Desktop Entry]
Name=Kitty
Comment=Code Editing. Redefined.
GenericName=Text Editor
Exec=/home/vagrant/.local/kitty.app/bin/kitty
Icon=/home/vagrant/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png
Type=Application
StartupNotify=false
StartupWMClass=Kitty
Categories=TextEditor;Development;IDE;
MimeType=text/plain;inode/directory;application/x-code-workspace;
Actions=new-empty-window;
Keywords=kitty;




font_family JetBrainsMono Nerd Font Mono
font_size 16.0
background_opacity 0.9