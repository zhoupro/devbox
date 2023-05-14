#!/bin/bash

source /vagrant_data/shs/utils.sh

echo "install zsh"

if (( $(dpkg -l | awk '{print $2}' | grep ^zsh | wc -l)==0 )) ;then
	echo "Install zsh"
	sudo apt-get install -y zsh
fi

proxy

if [ ! -d ~/.oh-my-zsh ];then
    sudo rm -rf ohmyzsh && \
	git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git && \
	sh  ohmyzsh/tools/install.sh --unattended  && \
	 sudo rm -rf ohmyzsh && \
	sudo usermod -s /bin/zsh  `whoami` 
	! (grep -F 'zsh-autosuggestions' ~/.zshrc &>/dev/null )  && \
	  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" && \
	  sed -E -i "s/plugins=\((.*)\)/plugins=\(\1 zsh-autosuggestions\)/g" ~/.zshrc


	! (grep -F 'zsh-syntax-highlighting' ~/.zshrc &>/dev/null )  && \
	   git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
	   sed -E -i "s/plugins=\((.*)\)/plugins=\(\1 zsh-syntax-highlighting\)/g" ~/.zshrc


	#zsh pure
	if [ ! -d "$HOME/.zsh/pure" ];then
	    git clone --depth=1 https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
	fi

	! (grep -F 'pure' ~/.zshrc &>/dev/null )  && \
	cat >> ~/.zshrc <<END
	fpath+=\$HOME/.zsh/pure
	autoload -U promptinit; promptinit
	prompt pure
END

cat >> ~/.zshrc <<END
set -o vi
export EDITOR=nvim
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line  
END


    
fi
echo "export PATH=\$PATH:/usr/local/bin/nodejs/node/bin" >> ~/.zshrc
echo "export PATH=\$PATH:\$HOME/.local/bin" >> ~/.zshrc
noproxy
