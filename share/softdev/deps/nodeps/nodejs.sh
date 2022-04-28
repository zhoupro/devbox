# nodejs

source ./basesoft.sh

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