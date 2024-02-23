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
         echo "export PATH=\$PATH:/usr/local/bin/nodejs/node/bin" >> ~/.customrc
    fi
}

install_node_server 20.11.1

/usr/local/lib/nodejs/node/bin/npm install -g yarn

#w2
if [ ! -f /usr/local/bin/w2 ];then
     /usr/local/lib/nodejs/node/bin/npm install whistle -g 
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

# npm install -g browser-sync --registry=https://registry.npm.taobao.org