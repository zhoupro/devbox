# apt package
aptenv(){
  apt-get update
  declare -a myarray
 
  myarray=(
            git  unrar p7zip    build-essential 
            wget curl axel gdebi fcitx
            zsh python3-pip 
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


#pip speed
mkdir $HOME/.pip
cat > $HOME/.pip/pip.conf << EOF
 [global]
 trusted-host=mirrors.aliyun.com
 index-url=http://mirrors.aliyun.com/pypi/simple/
EOF




