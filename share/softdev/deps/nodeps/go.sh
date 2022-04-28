source ./basesoft.sh

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