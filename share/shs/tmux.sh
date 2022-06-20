#!/bin/bash
source /vagrant_data/shs/utils.sh
echo "install tmux"

if (( $(dpkg -l | awk '{print $2}' | grep ^tmux | wc -l)==0 )) ;then
	echo "Install tmux"
	apt-get install -y tmux  tmux-plugin-manager tmuxinator
fi



cat <<EOF > ~/.tmux.conf
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

# other plugins
set -g @plugin 'dracula/tmux'
set -g @dracula-plugins "battery cpu-usage ram-usage"


# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '/usr/share/tmux-plugin-manager/tpm'
EOF