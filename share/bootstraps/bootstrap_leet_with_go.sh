#!/bin/bash
### utils
source /vagrant_data/shs/utils.sh

### basesoft
source /vagrant_data/shs/basesoft.sh


### vim
proxy
sudo -E -H -u vagrant bash /vagrant_data/shs/neovim.sh
noproxy

