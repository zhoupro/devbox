#!/bin/bash
echo "install awesome"

sudo rm -rf /usr/bin/fsed
sudo tee /usr/bin/fsed <<'END'
	#!/bin/bash
	LINENUMBER="$( fgrep -n "$1" "$3" | cut -d':' -f1 )"
	NEWSTRING="$2"
	sed -i "${LINENUMBER}s/.*/$2/" "$3"
END
sudo chmod u+x /usr/bin/fsed

#awesome
export CUSTOM_HOME=$HOME
sudo apt-get install -y   awesome
sudo apt-get install -y   rofi    feh xcompmgr  flameshot  x11-apps
sudo mkdir -p $CUSTOM_HOME/.config/awesome



sudo cp /etc/xdg/awesome/rc.lua $CUSTOM_HOME/.config/awesome/rc.lua
#sudo sed -i 's/"Mod4"/"Mod1"/g' $CUSTOM_HOME/.config/awesome/rc.lua

sudo sed -i 's/x-terminal-emulator/alacritty/g' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i 's/mylauncher,/--mylauncher,/g' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i 's/titlebars_enabled = true/titlebars_enabled = false/g' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i '$a\awful.util.spawn("bash /vagrant_data/shs/custom/feh.sh")' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i '$a\awful.util.spawn("xcompmgr &")' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i '$a\awful.util.spawn("xfce4-volumed &")' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i '$a\awful.util.spawn("xfce4-power-manager &")' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i '$a\awful.util.spawn("flameshot")' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i '$a\awful.util.spawn("xfce4-clipman")' $CUSTOM_HOME/.config/awesome/rc.lua

sudo sed -i '$a\awful.util.spawn("/usr/local/go/bin/go run $CUSTOM_HOME/github/copyproxy/main.go &")' $CUSTOM_HOME/.config/awesome/rc.lua

sudo fsed  'awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])' 'awful.tag({  "", "", "", "",""  }, s, awful.layout.layouts[7])'  $CUSTOM_HOME/.config/awesome/rc.lua


read -r -d '' VAR <<-'EOF'
sig_add = true
EOF
sudo sed -i "s/Notification library/Notification library@$(echo "$VAR"|tr "\n" "@")/g;s/@/\n/g" $CUSTOM_HOME/.config/awesome/rc.lua

read -r -d '' VAR <<-'EOF'
	awful.key({ modkey,           }, "q",
	function ()  
	awful.util.spawn("rofi -show run")
	end,
	{description = "rofi", group = "client"}),
EOF
sudo sed -i "s/Layout manipulation/Layout manipulation@$(echo "$VAR"|tr "\n" "@")/g;s/@/\n/g" $CUSTOM_HOME/.config/awesome/rc.lua

read -r -d '' VAR <<-'EOF'
	awful.key({ modkey,           }, "c",
	function ()  
	awful.util.spawn("rofi -show window")
	end,
	{description = "rofi", group = "client"}),
EOF
sudo sed -i "s/Layout manipulation/Layout manipulation@$(echo "$VAR"|tr "\n" "@")/g;s/@/\n/g" $CUSTOM_HOME/.config/awesome/rc.lua

sudo sed -i "s!mytextclock,!--mytextclock,!g"  $CUSTOM_HOME/.config/awesome/rc.lua



read -r -d '' VAR <<-'EOF'
firefox_launcher  = awful.widget.launcher({ image = "/usr/share/icons/hicolor/48x48/apps/firefox.png", command = "firefox", spacing = 10 })
ocr_launcher  = awful.widget.launcher({ image = "/usr/share/icons/hicolor/48x48/apps/xfce4-whiskermenu.png", command = "/vagrant_data/shs/ocr.sh", spacing = 10 })
EOF
sudo sed -i "s!Menubar configuration!Menubar configuration@$(echo "$VAR"|tr "\n" "@")!g;s!@!\n!g" $CUSTOM_HOME/.config/awesome/rc.lua


read -r -d '' VAR <<-'EOF'
firefox_launcher,
ocr_launcher,
EOF
sudo sed -i "s!mylauncher,!mylauncher,@$(echo "$VAR"|tr "\n" "@")!g;s!@!\n!g" $CUSTOM_HOME/.config/awesome/rc.lua


sudo sed -i 's!theme.bg_normal     = "#222222"!theme.bg_normal     = "#535d6c"!g' /usr/share/awesome/themes/default/theme.lua
sudo sed -i 's!theme.bg_focus      = "#535d6c"!theme.bg_focus      = "#242e30"!g' /usr/share/awesome/themes/default/theme.lua


sudo sed -i 's!theme.bg_systray    = theme.bg_normal .. 50!theme.bg_systray    = theme.bg_normal!g' /usr/share/awesome/themes/default/theme.lua
sudo sed -i 's!theme.bg_systray    = theme.bg_normal!theme.bg_systray    = theme.bg_normal .. 50!g' /usr/share/awesome/themes/default/theme.lua
sudo sed -i 's!theme.font          = "sans 8"!theme.font          = "JetBrainsMono Nerd Font Mono 12"!g' /usr/share/awesome/themes/default/theme.lua
sudo sed -i 's!theme.fg_focus      = "#ffffff"!theme.fg_focus      = "#00ffef"!g' /usr/share/awesome/themes/default/theme.lua