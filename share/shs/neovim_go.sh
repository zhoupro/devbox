#!/bin/bash
source /vagrant_data/shs/utils.sh
echo "go vim install"
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

install_go_server 1.18.3


function go_vim_ins(){
    ! (grep -F 'fatih/vim-go' ~/.config/nvim/lua/plugins.lua &>/dev/null ) && \
    sed -i "/plugAddPoint/ause 'fatih/vim-go'" ~/.config/nvim/lua/plugins.lua
    export PATH=$PATH:/usr/local/go/bin:~/go/bin
    export GO111MODULE=on
    export GOPROXY=https://goproxy.cn
    proxy
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerInstall'
    noproxy
    nvim +'GoInstallBinaries' +qall
    #go get -u github.com/cweill/gotests/...
    nvim -E -c 'CocCommand go.install.tools' -c qall
    nvim +'CocInstall -sync coc-go' +qall
    ! ( grep -F "leetcode_solution_filetype" ~/.config/nvim/init.vim ) && \
    cat >> ~/.config/nvim/init.vim <<END
    let g:leetcode_solution_filetype='golang'
END
}

go_vim_ins

