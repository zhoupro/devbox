#!/bin/bash
runuser -l vagrant -c "bash /vagrant_data/shs/base.sh"
runuser -l vagrant -c "bash /vagrant_data/shs/usebase.sh"
runuser -l vagrant -c "bash /vagrant_data/shs/zsh.sh"
runuser -l vagrant -c "bash /vagrant_data/shs/devbase.sh"
runuser -l vagrant -c "bash /vagrant_data/shs/tmux.sh"
runuser -l vagrant -c "bash /vagrant_data/shs/alacritty.sh"
runuser -l vagrant -c "bash /vagrant_data/shs/awesome.sh"
runuser -l vagrant -c "bash /vagrant_data/shs/neovim_base_packer.sh"
runuser -l vagrant -c "bash /vagrant_data/shs/neovim_go.sh"
runuser -l vagrant -c "bash /vagrant_data/shs/after.sh"
runuser -l vagrant -c "bash /vagrant_data/shs/tiger_ins.sh"








