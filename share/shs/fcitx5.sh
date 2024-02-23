#!/bin/bash

sudo apt install -y fcitx5
sudo apt install -y fcitx5-chinese-addons
sudo apt install -y fcitx5-frontend-gtk3 fcitx5-frontend-gtk2
sudo apt install -y fcitx5-frontend-qt5 kde-config-fcitx5
sudo apt install -y fcitx5-rime
rm  ~/.local/share/fcitx5/rime -rf && git clone --depth 1 https://github.com/iDvel/rime-ice ~/.local/share/fcitx5/rime
sudo im-config -n fcitx5