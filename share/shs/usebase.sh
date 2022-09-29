#!/bin/bash

source /vagrant_data/shs/utils.sh
echo "install usebase"
sudo sed -i -E 's/http:\/\/cn.(archive|security).ubuntu.com/https:\/\/mirrors.aliyun.com/g' /etc/apt/sources.list
sudo rm -f /var/lib/dpkg/lock-frontend
sudo rm -f /var/lib/dpkg/lock
sudo rm -f /var/cache/apt/archives/lock
sudo apt remove -y unattended-upgrades update-notifier



# apt package
aptenv(){
   sudo apt-get update
   declare -a myarray
 
  myarray=(
            git  unrar p7zip   
            wget curl axel gdebi fcitx shotwell
         )
	
	for i in ${myarray[@]};
	do
	   if (( $(dpkg -l | awk '{print $2}' | grep ^$i | wc -l)==0 )) ;then
        echo Install $i
	       sudo apt-get install -y $i;
	   fi
	done
}

#base apt
aptenv

sudo apt-get remove -y ibus
sudo apt-get purge -y ibus
sudo apt install -y fcitx-pinyin locales
sudo locale-gen zh_CN.UTF-8
sudo im-config -n fcitx



# font
if [ ! -f /usr/share/fonts/jetfont.ttf ];then
     sudo cp  /vagrant_data/jetfont.ttf   /usr/share/fonts/jetfont.ttf
     sudo fc-cache -f -v
fi


# nodejs
function install_node_server(){
    echo "intall nodejs"
    SERVER_VERSION=$1
    if [ -f  /usr/local/bin/node ]
    then
        echo "nodejs had installed"
        return
    fi
    sudo  rm -rf node-v${SERVER_VERSION}-linux-x64.tar.xz
    sudo  rm -rf /usr/local/bin/npm
    sudo  rm -rf /usr/local/bin/node

    if [ ! -f  node-v${SERVER_VERSION}-linux-x64.tar.xz ];then
        sudo  rm -rf /usr/local/lib/nodejs && \
        sudo mkdir -p /usr/local/lib/nodejs && sudo chmod 777 -R /usr/local/lib/nodejs && \
        axel -n 6 -o node-v${SERVER_VERSION}-linux-x64.tar.xz https://npmmirror.com/mirrors/node/v${SERVER_VERSION}/node-v${SERVER_VERSION}-linux-x64.tar.xz && \ 
         tar -C /usr/local/lib/nodejs -xJf   node-v${SERVER_VERSION}-linux-x64.tar.xz && \
         sudo mv /usr/local/lib/nodejs/node-v${SERVER_VERSION}-linux-x64  /usr/local/lib/nodejs/node && \
         sudo rm -rf node-v${SERVER_VERSION}-linux-x64.tar.xz && \
         sudo ln -s  /usr/local/lib/nodejs/node/bin/npm /usr/local/bin/npm && \
         sudo ln -s  /usr/local/lib/nodejs/node/bin/node /usr/local/bin/node && \
         echo "export PATH=\$PATH:/usr/local/bin/nodejs/node/bin" >> ~/.bashrc
    fi
}

install_node_server 16.17.0



#w2
if [ ! -f /usr/local/bin/w2 ];then
     /usr/local/lib/nodejs/node/bin/npm install whistle -g --registry=https://registry.npm.taobao.org
     sudo ln -s  /usr/local/lib/nodejs/node/bin/w2 /usr/local/bin/w2
fi


 /usr/local/lib/nodejs/node/bin/w2 start > /dev/null
if [ -f $HOME/.WhistleAppData/.whistle/properties/properties ];then
    if ! grep interceptHttpsConnects $HOME/.WhistleAppData/.whistle/properties/properties ;then
        sed -i 's#{#{"interceptHttpsConnects":true,#g' $HOME/.WhistleAppData/.whistle/properties/properties
    fi
    sed -i 's#"interceptHttpsConnects":false#"interceptHttpsConnects":true#g' $HOME/.WhistleAppData/.whistle/properties/properties
fi

 /usr/local/lib/nodejs/node/bin/w2 restart > /dev/null
 /usr/local/lib/nodejs/node/bin/w2 add /vagrant_data/conf/.whistle.js --force

npm install -g awk-language-server --registry=https://registry.npm.taobao.org
npm i -g bash-language-server --registry=https://registry.npm.taobao.org
