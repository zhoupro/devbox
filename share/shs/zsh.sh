#!/bin/bash

if [ ! -d /home/vagrant/.oh-my-zsh ];then
        pxy git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
        cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
        chsh -s $(which zsh)
	#sh -c "$(pxy curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	sudo usermod -s /bin/zsh vagrant


	! (grep -F 'zsh-autosuggestions' ~/.zshrc &>/dev/null )  && \
	pxy git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" && \
	sed -E -i "s/plugins=\((.*)\)/plugins=\(\1 zsh-autosuggestions\)/g" ~/.zshrc


	! (grep -F 'zsh-syntax-highlighting' ~/.zshrc &>/dev/null )  && \
	pxy git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
	sed -E -i "s/plugins=\((.*)\)/plugins=\(\1 zsh-syntax-highlighting\)/g" ~/.zshrc



	#zsh pure
	if [ ! -d "$HOME/.zsh/pure" ];then
	    pxy git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
	fi

	! (grep -F 'pure' ~/.zshrc &>/dev/null )  && \
	cat >> ~/.zshrc <<END
	fpath+=\$HOME/.zsh/pure
	autoload -U promptinit; promptinit
	prompt pure
END
    
fi

