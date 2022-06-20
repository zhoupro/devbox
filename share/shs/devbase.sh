#!/bin/bash

source /vagrant_data/shs/utils.sh
echo "install devbase"

# apt package
aptenv(){
   apt-get update
  declare -a myarray
 
  myarray=(
            build-essential 
            python3-pip exuberant-ctags
            lua5.3
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

if (( $(dpkg -l | awk '{print $2}' | grep ^bat | wc -l)==0 )) ;then
    echo "bat"
    apt install -y -o Dpkg::Options::="--force-overwrite" bat ripgrep
fi

#pip speed
if [ ! -d $HOME/.pip ];then
   mkdir $HOME/.pip
fi

cat > $HOME/.pip/pip.conf << EOF
 [global]
 trusted-host=mirrors.aliyun.com
 index-url=http://mirrors.aliyun.com/pypi/simple/
EOF







