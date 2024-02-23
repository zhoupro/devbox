
source /vagrant_data/shs/utils.sh
echo "install basesoft"


# sudo apt-get install -y software-properties-common
# sudo add-apt-repository -y ppa:git-core/ppa


# apt package
aptenv(){
   sudo apt-get update
  declare -a myarray
 
  myarray=(
            locales tig xclip xsel fzf meld gpick
            tmux-plugin-manager fuse 
            git  unrar p7zip    build-essential 
            wget curl axel gdebi 
            zsh python3-pip exuberant-ctags
            lua5.3 jq  shotwell dos2unix
         )
	
	for i in ${myarray[@]};
	do
	   if (( $(dpkg -l | awk '{print $2}' | grep ^$i | wc -l)==0 )) ;then
        echo Install $i
	       sudo apt-get install -y $i;
	   fi
	done
}

#base apt
aptenv


if (( $(dpkg -l | awk '{print $2}' | grep ^bat | wc -l)==0 )) ;then
    echo "bat"
    sudo apt install -y -o Dpkg::Options::="--force-overwrite" bat ripgrep
fi

#pip speed
mkdir -p $HOME/.pip

cat > $HOME/.pip/pip.conf << EOF
 [global]
 trusted-host=mirrors.aliyun.com
 index-url=http://mirrors.aliyun.com/pypi/simple/
EOF


if [ ! -f /usr/bin/google-chrome ];then
   wget 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb' &&\
	sudo gdebi -n google-chrome-stable_current_amd64.deb && sudo rm -f google-chrome-stable_current_amd64.deb
fi

sudo cp /vagrant_data/conf/docker-service/mongo/mongosh.sh /usr/local/bin/mongosh && \
sudo chmod 777 -R /usr/local/bin/mongosh

sudo cp /vagrant_data/conf/docker-service/mysql/mysql.sh /usr/local/bin/mysql && \
sudo chmod 777 -R /usr/local/bin/mysql


sudo apt-get remove -y ibus
sudo apt-get purge -y ibus
sudo apt install -y  locales
sudo locale-gen zh_CN.UTF-8



# font
if [ ! -f /usr/share/fonts/jetfont.ttf ];then
     sudo cp  /vagrant_data/jetfont.ttf   /usr/share/fonts/jetfont.ttf
     sudo fc-cache -f -v
fi