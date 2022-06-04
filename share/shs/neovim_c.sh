#!/bin/bash
echo "c vim"
if [ ! -f /usr/bin/clangd ];then
    axel -n 10 -o clangd-linux-14.0.3.zip  https://github.com//clangd/clangd/releases/download/14.0.3/clangd-linux-14.0.3.zip && \
    unzip clangd-linux-14.0.3.zip && \
    ln -s `pwd`/clangd_14.0.3/bin/clangd /usr/bin/clangd
    ~/.local/share/nvim/site/pack/packer/start/vimspector/install_gadget.py --sudo --no-check-certificate --enable-c
 fi

nvim "+CocInstall -sync coc-clangd" +qall 

