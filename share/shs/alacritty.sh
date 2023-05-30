#!/bin/bash
echo "install alacritty"

if (( $(dpkg -l | awk '{print $2}' | grep ^alacritty | wc -l)==0 )) ;then
    axel -n 6 -o  alacritty.deb https://github.com/barnumbirr/alacritty-debian/releases/download/v0.12.0-1/alacritty_0.12.0_amd64_bullseye.deb && \
    sudo gdebi -n alacritty.deb && rm -f alacritty.deb
fi

mkdir -p /home/vagrant/.config/alacritty && \
 cp /vagrant_data/conf/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml && \
 cp /vagrant_data/conf/alacritty/dracula.yml ~/.config/alacritty/dracula.yml
