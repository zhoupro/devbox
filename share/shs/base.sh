#!/bin/bash
# apt package
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:git-core/ppa


aptenv(){
   apt-get update
   declare -a myarray
 
  myarray=(
            git  unrar p7zip   
            wget curl axel gdebi 
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