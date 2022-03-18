#!/bin/bash
getDownloadUrl(){
    echo $1
}


proxy() {
    if  [  -z $1 ];then
        prox="http://localhost:8899"
    else
        prox=$1
    fi
    echo $prox

    export ALL_PROXY="$prox"
    export all_proxy="$prox"
    export https_proxy="$prox"
    export http_proxy="$prox"
    #/usr/local/lib/nodejs/node/bin/npm
    /usr/local/lib/nodejs/node/bin/npm config set proxy "$prox"
    /usr/local/lib/nodejs/node/bin/npm config set http-proxy "$prox"
    /usr/local/lib/nodejs/node/bin/npm config set https-proxy "$prox"
    /usr/local/lib/nodejs/node/bin/npm set strict-ssl false
    #git
    git config --global http.proxy "$prox"
    git config --global https.proxy "$prox"
    git config --global http.sslVerify false
    git config --global https.sslVerify false

    #go
    #export GOPROXY=https://goproxy.cn
    

    /usr/local/go/bin/go env -w GO111MODULE=on 
    #go env -w GOPROXY=https://goproxy.cn,direct
   /usr/local/go/bin/go env -w GOPROXY=https://goproxy.cn,direct

    # ca cert
    /usr/local/lib/nodejs/node/bin/w2 start >/dev/null
    curl http://localhost:8899/cgi-bin/rootca -o   /usr/local/share/ca-certificates/rootCA.crt
    update-ca-certificates
    /usr/local/lib/nodejs/node/bin/w2 restart >/dev/null
}

noproxy() {
    unset ALL_PROXY
    unset all_proxy 
    unset https_proxy
    unset http_proxy
    #/usr/local/lib/nodejs/node/bin/npm
    /usr/local/lib/nodejs/node/bin/npm config delete proxy
    /usr/local/lib/nodejs/node/bin/npm config delete http-proxy
    /usr/local/lib/nodejs/node/bin/npm config delete https-proxy
    /usr/local/lib/nodejs/node/bin/npm config delete set-strict-ssl
    #git
    git config --global --unset http.proxy 
    git config --global --unset  https.proxy 
    #go
    #unset GOPROXY

}