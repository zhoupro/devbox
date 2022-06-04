#!/bin/bash
echo "php vim"
apt install -y php

nvim "+CocInstall coc-phpls" +qall 


