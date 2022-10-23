
source /vagrant_data/shs/utils.sh
echo "install basesoft"

# apt package
aptenv(){
   sudo apt-get update
  declare -a myarray
 
  myarray=(
            git  unrar p7zip    build-essential 
            wget curl axel gdebi fcitx
            zsh python3-pip exuberant-ctags
            lua5.3 
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

sudoapt install -y -o Dpkg::Options::="--force-overwrite" bat ripgrep

#pip speed
mkdir $HOME/.pip

cat > $HOME/.pip/pip.conf << EOF
 [global]
 trusted-host=mirrors.aliyun.com
 index-url=http://mirrors.aliyun.com/pypi/simple/
EOF




# font
if [ ! -f /usr/share/fonts/jetfont.ttf ];then
     cp  /vagrant_data/jetfont.ttf   /usr/share/fonts/jetfont.ttf
     sudo fc-cache -f -v
fi


