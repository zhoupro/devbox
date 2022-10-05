#!/bin/bash
source /vagrant_data/shs/utils.sh
echo "install tmux"

if (( $(dpkg -l | awk '{print $2}' | grep ^tmux | wc -l)==0 )) ;then
	echo "Install tmux"
	sudo apt-get install -y tmux  tmux-plugin-manager tmuxinator
fi



cat <<EOF > ~/.tmux.conf
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'samoshkin/tmux-plugin-sysstat'
set -g @plugin 'tmux-plugins/tmux-battery'
set -g @plugin 'tmux-plugins/tmux-net-speed'


set -g @sysstat_mem_view_tmpl 'RAM:#{mem.used}/#{mem.total}'
set -g status-right "#{sysstat_cpu} |#{sysstat_mem}|BAT:#{battery_percentage}|NET:#{download_speed}"
set -g @download_speed_format "%7s"


# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '/usr/share/tmux-plugin-manager/tpm'
EOF