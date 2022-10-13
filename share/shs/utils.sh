#!/bin/bash
getDownloadUrl(){
    echo $1
}

proxy() {
    #CUSTOM_PROXY="http://192.168.56.1:7890"
    if  [[ ! -z $CUSTOM_PROXY ]] ;then
         prox=$CUSTOM_PROXY
    elif [[ ! -z "$1"  ]]; then
        prox=$1
    else
        prox=""
    fi

    echo $prox

    export ALL_PROXY="$prox"
    export all_proxy="$prox"
    export https_proxy="$prox"
    export http_proxy="$prox"
    #git
    git config --global http.proxy "$prox"
    git config --global https.proxy "$prox"
    git config --global http.sslVerify false
    git config --global https.sslVerify false
    if [ -f /usr/local/go/bin/go ];then
         /usr/local/go/bin/go env -w GO111MODULE=on 
         /usr/local/go/bin/go env -w GOPROXY=https://goproxy.cn,direct
    fi
}


noproxy() {
    echo "noproxy"
    unset ALL_PROXY
    unset all_proxy 
    unset https_proxy
    unset http_proxy
    #git
    git config --global --unset http.proxy 
    git config --global --unset  https.proxy 
}
