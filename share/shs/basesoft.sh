
source /vagrant_data/shs/utils.sh

# apt package
aptenv(){
   apt-get update
  declare -a myarray
 
  myarray=(
            git  unrar p7zip    build-essential 
            wget curl axel gdebi fcitx
            zsh python3-pip exuberant-ctags
         )
	
	for i in ${myarray[@]};
	do
	   if (( $(dpkg -l | awk '{print $2}' | grep ^$i | wc -l)==0 )) ;then
        echo Install $i
	       apt-get install -y $i;
	   fi
	done
}

#base apt
aptenv

#pip speed
mkdir $HOME/.pip

cat > $HOME/.pip/pip.conf << EOF
 [global]
 trusted-host=mirrors.aliyun.com
 index-url=http://mirrors.aliyun.com/pypi/simple/
EOF


# nodejs
function install_node_server(){
    SERVER_VERSION=$1
    if [ -f  /usr/local/bin/node ]
    then
        echo "nodejs had installed"
        return
    fi
     rm -rf node-v${SERVER_VERSION}-linux-x64.tar.xz
     rm -rf /usr/local/bin/npm
     rm -rf /usr/local/bin/node

    if [ ! -f  node-v${SERVER_VERSION}-linux-x64.tar.xz ];then
         rm -rf /usr/local/lib/nodejs && \
         mkdir -p /usr/local/lib/nodejs && \
         axel -n 6 -o node-v${SERVER_VERSION}-linux-x64.tar.xz https://nodejs.org/dist/v${SERVER_VERSION}/node-v${SERVER_VERSION}-linux-x64.tar.xz && \
         tar -C /usr/local/lib/nodejs -xJf   node-v${SERVER_VERSION}-linux-x64.tar.xz && \
         mv /usr/local/lib/nodejs/node-v${SERVER_VERSION}-linux-x64  /usr/local/lib/nodejs/node && \
         rm -rf node-v${SERVER_VERSION}-linux-x64.tar.xz
         ln -s  /usr/local/lib/nodejs/node/bin/npm /usr/local/bin/npm
         ln -s  /usr/local/lib/nodejs/node/bin/node /usr/local/bin/node
         echo "export PATH=\$PATH:/usr/local/bin/nodejs/node/bin" >> ~/.zshrc
         echo "export PATH=\$PATH:/usr/local/bin/nodejs/node/bin" >> ~/.bashrc
    fi
}

install_node_server 14.18.0
install_node_server 14.18.0

 cp /vagrant_data/conf/rootCA.crt /usr/local/share/ca-certificates/
 update-ca-certificates

#w2
if [ ! -f /usr/local/bin/w2 ];then
     /usr/local/lib/nodejs/node/bin/npm install whistle -g --registry=https://registry.npm.taobao.org
     ln -s  /usr/local/lib/nodejs/node/bin/w2 /usr/local/bin/w2
fi

 /usr/local/lib/nodejs/node/bin/w2 start
if [ -f $HOME/.WhistleAppData/.whistle/properties/properties ];then
    if ! grep interceptHttpsConnects $HOME/.WhistleAppData/.whistle/properties/properties ;then
        sed -i 's#{#{"interceptHttpsConnects":true,#g' $HOME/.WhistleAppData/.whistle/properties/properties
    fi
    sed -i 's#"interceptHttpsConnects":false#"interceptHttpsConnects":true#g' $HOME/.WhistleAppData/.whistle/properties/properties
fi

 /usr/local/lib/nodejs/node/bin/w2 restart
 /usr/local/lib/nodejs/node/bin/w2 add /vagrant_data/conf/.whistle.js --force

# golang
function install_go_server(){
    SERVER_VERSION=$1
    if [ -f  /usr/local/go/bin/go ]
    then
        echo "go had installed"
        return
    fi

    if [ ! -f  go${SERVER_VERSION}.linux-amd64.tar.gz ];then
         axel -n 40 -o go${SERVER_VERSION}.linux-amd64.tar.gz https://dl.google.com/go/go${SERVER_VERSION}.linux-amd64.tar.gz && \
         tar -C /usr/local -xzf  go${SERVER_VERSION}.linux-amd64.tar.gz && \
        rm -rf go${SERVER_VERSION}.linux-amd64.tar.gz 
    fi
    export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
     echo "export PATH=\$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.zshrc
     echo "export PATH=\$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bashrc
}

install_go_server 1.17.7
install_go_server 1.17.7

proxy
source /vagrant_data/shs/zsh.sh
noproxy


#sogou
if (( $(dpkg -l | awk '{print $2}' | grep ^sogou | wc -l)==0 )) ;then
    if [ ! -f /vagrant_data/soft/sogou.deb ];then
      axel -n 40 -o /vagrant_data/soft/sogou.deb 'http://cdn2.ime.sogou.com/dl/index/1599192613/sogoupinyin_2.3.2.07_amd64-831.deb?st=1cXIZ9xRzyq4GPkctOsB3Q&e=1602396489&fn=sogoupinyin_2.3.2.07_amd64-831.deb'
    fi
     gdebi -n /vagrant_data/soft/sogou.deb 
fi

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

# font
if [ ! -f /usr/share/fonts/jetfont.ttf ];then
     cp  /vagrant_data/jetfont.ttf   /usr/share/fonts/jetfont.ttf
     fc-cache -f -v
fi


