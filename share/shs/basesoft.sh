
source /vagrant_data/shs/utils.sh

# apt package
aptenv(){
  sudo apt-get update
  sudo apt-get  autoremove -y
  declare -a myarray
 
  myarray=(
            git  unrar p7zip    build-essential 
            wget curl axel gdebi fcitx
            zsh python3-pip 
         )
	
	for i in ${myarray[@]};
	do
	   if (( $(dpkg -l | awk '{print $2}' | grep ^$i | wc -l)==0 )) ;then
        echo Install $i
	     sudo  apt-get install -y $i;
	   fi
	done
}

#base apt
aptenv

#sogou
if (( $(dpkg -l | awk '{print $2}' | grep ^sogou | wc -l)==0 )) ;then
    if [ ! -f /vagrant_data/soft/sogou.deb ];then
      axel -n 40 -o /vagrant_data/soft/sogou.deb 'http://cdn2.ime.sogou.com/dl/index/1599192613/sogoupinyin_2.3.2.07_amd64-831.deb?st=1cXIZ9xRzyq4GPkctOsB3Q&e=1602396489&fn=sogoupinyin_2.3.2.07_amd64-831.deb'
    fi
    sudo gdebi -n /vagrant_data/soft/sogou.deb 
fi

#lantern
if (( $(dpkg -l | awk '{print $2}' | grep ^lantern | wc -l)==0 )) ;then

    if [ ! -f /vagrant_data/soft/lantern.deb ];then
      axel -n 50 -o /vagrant_data/soft/lantern.deb 'https://s3.amazonaws.com/lantern/lantern-installer-64-bit.deb'
    fi
    sudo gdebi -n /vagrant_data/soft/lantern.deb 
    
 fi

if [  -f /home/vagrant/.lantern/settings.yaml ] ;then
      # config replace
      sudo sed -i 's/addr.*/addr : 0\.0\.0\.0:8087/g' /home/vagrant/.lantern/settings.yaml
      sudo sed -i 's/uiAddr.*/uiAddr : 0\.0\.0\.0:8080/g' /home/vagrant/.lantern/settings.yaml
fi

# font
if [ ! -f /usr/share/fonts/jetfont.ttf ];then
    sudo cp  /vagrant_data/jetfont.ttf   /usr/share/fonts/jetfont.ttf
    sudo fc-cache -f -v
fi

# nodejs
function install_node_server(){
    SERVER_VERSION=$1
    if [ -f  /usr/local/bin/node ]
    then
        echo "nodejs had installed"
        return
    fi

    if [ ! -f  node-v${SERVER_VERSION}-linux-x64.tar.xz ];then
        sudo mkdir -p /usr/local/lib/nodejs && \
        sudo axel -n 40 -o node-v${SERVER_VERSION}-linux-x64.tar.xz https://nodejs.org/dist/v${SERVER_VERSION}/node-v${SERVER_VERSION}-linux-x64.tar.xz && \
        sudo tar -C /usr/local/lib/nodejs -xJf   node-v${SERVER_VERSION}-linux-x64.tar.xz && \
        sudo mv /usr/local/lib/nodejs/node-v${SERVER_VERSION}-linux-x64  /usr/local/lib/nodejs/node && \
        sudo rm -rf node-v${SERVER_VERSION}-linux-x64.tar.xz
    fi
    sudo ln -s  /usr/local/lib/nodejs/node/bin/npm /usr/local/bin/npm
    sudo ln -s  /usr/local/lib/nodejs/node/bin/node /usr/local/bin/node
}

install_node_server 14.18.0

if [ ! -f /usr/local/bin/w2 ];then
    sudo npm install whistle -g --registry=https://registry.npm.taobao.org
    sudo ln -s  /usr/local/lib/nodejs/node/bin/w2 /usr/local/bin/w2
fi

sudo -H -u vagrant /usr/local/lib/nodejs/node/bin/w2 start
if [ -f /home/vagrant/.WhistleAppData/.whistle/properties/properties ];then
    sed -i 's#"interceptHttpsConnects":false#"interceptHttpsConnects":true#g' /home/vagrant/.WhistleAppData/.whistle/properties/properties
fi
sudo -H -u vagrant /usr/local/lib/nodejs/node/bin/w2 add /vagrant_data/conf/.whistle.js --force
sudo -H -u vagrant /usr/local/lib/nodejs/node/bin/w2 restart


# golang
function install_go_server(){
    SERVER_VERSION=$1

    if [ -f  /usr/local/go/bin/go ]
    then
        echo "go had installed"
        return
    fi

    if [ ! -f  go${SERVER_VERSION}.linux-amd64.tar.gz ];then
        sudo axel -n 40 -o go${SERVER_VERSION}.linux-amd64.tar.gz https://dl.google.com/go/go${SERVER_VERSION}.linux-amd64.tar.gz && \
        sudo tar -C /usr/local -xzf  go${SERVER_VERSION}.linux-amd64.tar.gz && \
        rm -rf go${SERVER_VERSION}.linux-amd64.tar.gz 
    fi
    export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
    sudo echo "export PATH=\$PATH:/usr/local/go/bin:$HOME/go/bin" >> /home/vagrant/.zshrc
}
install_go_server 1.17.7




