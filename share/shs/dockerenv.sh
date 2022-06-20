#!/usr/bin/env bash
echo "install docker env"

#docker devevlop enviroment
dockerenv(){
    if (( $( which docker | wc -l)==0 )) ;then
        curl -sSL https://get.daocloud.io/docker | sh
        sudo service docker start
        sudo groupadd docker
        sudo usermod -aG docker $uname
    fi

    if (( $( which docker-compose | wc -l)==0 )) ;then
        pip install -U docker-compose
    fi
    sudo mkdir -p /etc/docker
    sudo tee /etc/docker/daemon.json <<-'EOF'
    {
    "registry-mirrors": ["https://pg3p5mmo.mirror.aliyuncs.com"]
    }
EOF
    sudo systemctl daemon-reload
    sudo systemctl restart docker

}

dockerenv