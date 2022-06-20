#!/bin/bash
echo "install alacritty"

if (( $(dpkg -l | awk '{print $2}' | grep ^alacritty | wc -l)==0 )) ;then
    axel -n 6 -o  alacritty.deb https://github.com/barnumbirr/alacritty-debian/releases/download/v0.10.1-1/alacritty_0.10.1-1_amd64_bullseye.deb && \
    gdebi -n alacritty.deb && rm -f alacritty.deb
fi

mkdir -p /home/vagrant/.config/alacritty && \
 cp /vagrant_data/conf/alacritty/alacritty.yml /home/vagrant/.config/alacritty/alacritty.yml
