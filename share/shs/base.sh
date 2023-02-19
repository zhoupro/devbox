#!/bin/bash
# apt package
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:git-core/ppa


aptenv(){
   sudo apt-get update
   declare -a myarray
 
  myarray=(
            git  unrar p7zip   locales tig xclip xsel fzf meld gpick
            wget curl axel gdebi tmux-plugin-manager fuse numix-icon-theme-circle
         )
	
	for i in ${myarray[@]};
	do
	   if (( $(dpkg -l | awk '{print $2}' | grep ^$i | wc -l)==0 )) ;then
        echo Install $i
	       sudo apt-get install -y $i;
	   fi
	done
}

if [ ! -f /usr/bin/google-chrome ];then
   wget 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb' &&\
	sudo gdebi -n google-chrome-stable_current_amd64.deb && sudo rm -f google-chrome-stable_current_amd64.deb
fi

#base apt
aptenv

