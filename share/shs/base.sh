#!/bin/bash
# apt package
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:git-core/ppa


aptenv(){
   sudo apt-get update
   declare -a myarray
 
  myarray=(
            git  unrar p7zip   locales tig xclip xsel fzf
            wget curl axel gdebi tmux-plugin-manager
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

