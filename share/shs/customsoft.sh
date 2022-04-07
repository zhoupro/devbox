#!/bin/bash

#lantern
if (( $(dpkg -l | awk '{print $2}' | grep ^lantern | wc -l)==0 )) ;then

    if [ ! -f /vagrant_data/soft/lantern.deb ];then
      axel -n 50 -o /vagrant_data/soft/lantern.deb 'https://s3.amazonaws.com/lantern/lantern-installer-64-bit.deb'
    fi
     gdebi -n /vagrant_data/soft/lantern.deb 
    
 fi

if [  -f ~/.lantern/settings.yaml ] ;then
      # config replace
       sed -i 's/addr.*/addr : 0\.0\.0\.0:8087/g' ~/.lantern/settings.yaml
       sed -i 's/uiAddr.*/uiAddr : 0\.0\.0\.0:8080/g' ~/.lantern/settings.yaml
fi


#code

sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt install apt-transport-https
sudo apt update
sudo apt install code # or code-insiders