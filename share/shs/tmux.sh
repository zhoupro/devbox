#!/bin/bash
source /vagrant_data/shs/utils.sh
echo "install tmux"

if (( $(dpkg -l | awk '{print $2}' | grep ^tmux-plugin-manager | wc -l)==0 )) ;then
	echo "Install tmux"
	sudo apt-get install -y tmux  tmux-plugin-manager tmuxinator
fi



cat <<EOF > ~/.tmux.conf

bind-key / copy-mode \; send-key ?
setw -g mode-keys vi
set -g base-index 1
set -g status-interval 1
set -g status-style fg=colour136,bg="#002b36"
set -g status-right-length 140
set -g status-position top # [top, bottom]


set -g @fuzzback-fzf-bind 'ctrl-y:execute-silent(echo -n {3..} | xsel -ib)+abort'
set -g @fuzzback-bind z



# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'samoshkin/tmux-plugin-sysstat'
set -g @plugin 'tmux-plugins/tmux-battery'
set -g @plugin 'tmux-plugins/tmux-net-speed'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'tmux-plugins/tmux-copycat'
set -g @plugin 'roosta/tmux-fuzzback'



# Set the inactive window color and style

set -g window-status-style fg=colour244,bg=default
set -g window-status-format ' #I #W '

# Set the active window color and style
set -g window-status-current-style fg=black,bg=colour136
set -g window-status-current-format ' #I #W '



set -g @sysstat_mem_view_tmpl 'RAM:#{mem.used}/#{mem.total}'
set -g @sysstat_cpu_view_tmpl 'CPU:#{cpu.pused}'

set -g status-right "#{sysstat_cpu} |#{sysstat_mem}|NET:#{download_speed}|BAT:#{battery_percentage}"
set -g @download_speed_format "%7s"

set-option -g set-titles on
bind-key s run -b "~/.tmux/plugins/tmux-fuzzback/scripts/fuzzback.sh";


# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '/usr/share/tmux-plugin-manager/tpm'

EOF
