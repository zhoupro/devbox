#!/bin/bash


sudo sed -i 's/addr.*/addr : 0\.0\.0\.0:8087/g' /home/vagrant/.lantern/settings.yaml
sudo sed -i 's/uiAddr.*/uiAddr : 0\.0\.0\.0:8080/g' /home/vagrant/.lantern/settings.yaml

# add aliyun dns
if ! grep -q "223.5.5.5" /etc/resolv.conf; then
    sudo sed -i '$a\nameserver 223.5.5.5' /etc/resolv.conf
    sudo sed -i '$a\nameserver 223.6.6.6' /etc/resolv.conf
fi

# change aliyun mirrors
sudo sed -i  's/cn.archive.ubuntu.com/mirrors.aliyun.com/g'  /etc/apt/sources.list
sudo sed -i  's/archive.ubuntu.com/mirrors.aliyun.com/g'  /etc/apt/sources.list
sudo apt update 
sudo  apt-get install -y   git curl fzf meld python3-pip flameshot xclip
sudo  apt-get install -y   clang clangd

# 安装
sudo apt-get -y update && \
    # tools
    sudo apt-get install -y wget curl net-tools locales bzip2 unzip iputils-ping \
    traceroute firefox firefox-locale-zh-hans ttf-wqy-microhei \
    gedit gdebi python  gnome-font-viewer thunar awesome xfce4-terminal xrdp dbus-x11

sudo apt-get -y update && \
   sudo apt-get remove -y ibus indicator-keyboard && sudo apt-get purge -y ibus && \
   sudo apt install -y fcitx-table-wbpy fcitx-config-gtk gdebi \
   gawk curl  zsh \
    git unzip wget    python3-pip  lsof sudo python \
    autojump  nmap iproute2 net-tools  axel netcat ripgrep fzf  xcompmgr feh libappindicator3-1 software-properties-common \
    konsole rofi



sudo rm -rf /vagrant_data
sudo mkdir /vagrant_data  && sudo chmod 777 /vagrant_data && cp -r share/*  /vagrant_data/




if  nc -zv localhost 8087 ;then
	sudo tee /usr/bin/pxy <<'END'
		#!/bin/bash
		export http_proxy=http://localhost:8087
		export https_proxy=http://localhost:8087
		starttime=$(date +%s)
		#执行程序
		"$@"
		endtime=$(date +%s)
		echo "use time： "$((endtime-starttime))"s"
		unset http_proxy
		unset https_proxy
END
else
	sudo tee /usr/bin/pxy <<'END'
		#!/bin/bash
		
		starttime=$(date +%s)
		#执行程序
		"$@"
		endtime=$(date +%s)
		echo "use time： "$((endtime-starttime))"s"
END

fi


sudo chmod 777 /usr/bin/pxy



# zsh
sudo apt install -y zsh


if [ ! -f /usr/share/fonts/jetfont.ttf ];then
    sudo cp  /vagrant_data/jetfont.ttf   /usr/share/fonts/jetfont.ttf
    sudo fc-cache -f -v
fi

function install_node_server(){
    SERVER_VERSION=$1
    if [ -f  /usr/local/bin/node ]
    then
        echo "nodejs had installed"
        return
    fi

    if [ ! -f  node-v${SERVER_VERSION}-linux-x64.tar.xz ];then
        sudo mkdir -p /usr/local/lib/nodejs && \
        sudo wget https://nodejs.org/dist/v${SERVER_VERSION}/node-v${SERVER_VERSION}-linux-x64.tar.xz && \
        sudo tar -C /usr/local/lib/nodejs -xJf   node-v${SERVER_VERSION}-linux-x64.tar.xz && \
        sudo mv /usr/local/lib/nodejs/node-v${SERVER_VERSION}-linux-x64  /usr/local/lib/nodejs/node
    fi
    sudo ln -s  /usr/local/lib/nodejs/node/bin/npm /usr/local/bin/npm
    sudo ln -s  /usr/local/lib/nodejs/node/bin/node /usr/local/bin/node
}

install_node_server 14.18.0

function install_go_server(){
    SERVER_VERSION=$1

    if [ -f  /usr/local/go/bin/go ]
    then
        echo "go had installed"
        return
    fi

    if [ ! -f  go${SERVER_VERSION}.linux-amd64.tar.gz ];then
        sudo wget https://dl.google.com/go/go${SERVER_VERSION}.linux-amd64.tar.gz
        sudo tar -C /usr/local -xzf  go${SERVER_VERSION}.linux-amd64.tar.gz
    fi
    export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
    sudo echo "export PATH=\$PATH:/usr/local/go/bin:$HOME/go/bin" >> /home/vagrant/.zshrc
}
install_go_server 1.17.1





sudo rm -rf /usr/bin/fsed
sudo tee /usr/bin/fsed <<'END'
	#!/bin/bash
	LINENUMBER="$( fgrep -n "$1" "$3" | cut -d':' -f1 )"
	NEWSTRING="$2"
	sed -i "${LINENUMBER}s/.*/$2/" "$3"
END
sudo chmod u+x /usr/bin/fsed


#awesome
sudo  apt-get install -y   awesome konsole
sudo  apt-get install -y   rofi vlc  goldendict ffmpeg feh  zathura
sudo mkdir -p /home/vagrant/.config/awesome
sudo cp /etc/xdg/awesome/rc.lua /home/vagrant/.config/awesome/rc.lua
sudo sed -i 's/"Mod4"/"Mod1"/g' /home/vagrant/.config/awesome/rc.lua
sudo sed -i 's/x-terminal-emulator/konsole/g' /home/vagrant/.config/awesome/rc.lua
sudo sed -i 's/mylauncher,/--mylauncher,/g' /home/vagrant/.config/awesome/rc.lua
sudo sed -i 's/titlebars_enabled = true/titlebars_enabled = false/g' /home/vagrant/.config/awesome/rc.lua
sudo sed -i '$a\awful.util.spawn("bash /vagrant_data/shs/feh.sh")' /home/vagrant/.config/awesome/rc.lua
sudo sed -i '$a\awful.util.spawn("goldendict")' /home/vagrant/.config/awesome/rc.lua
sudo sed -i '$a\awful.util.spawn("xcompmgr &")' /home/vagrant/.config/awesome/rc.lua
sudo sed -i '$a\awful.util.spawn("xfce4-volumed &")' /home/vagrant/.config/awesome/rc.lua
sudo sed -i '$a\awful.util.spawn("xfce4-power-manager &")' /home/vagrant/.config/awesome/rc.lua
sudo sed -i '$a\awful.util.spawn("blueman-applet")' /home/vagrant/.config/awesome/rc.lua
sudo sed -i '$a\awful.util.spawn("nm-applet  &")' /home/vagrant/.config/awesome/rc.lua
sudo sed -i '$a\awful.util.spawn("autorandr --change")' /home/vagrant/.config/awesome/rc.lua
sudo sed -i '$a\awful.util.spawn("flameshot")' /home/vagrant/.config/awesome/rc.lua
sudo sed -i '$a\awful.util.spawn("bash /vagrant_data/shs/bluetoothautoconnect.sh &")' /home/vagrant/.config/awesome/rc.lua

sudo fsed  'awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])' 'awful.tag({  "", "", "", "",""  }, s, awful.layout.layouts[7])'  /home/vagrant/.config/awesome/rc.lua

read -r -d '' VAR <<-'EOF'
	awful.key({ modkey,           }, "q",
	function ()  
	awful.util.spawn("rofi -show run")
	end,
	{description = "rofi", group = "client"}),
EOF

sudo sed -i "s/Layout manipulation/Layout manipulation@$(echo "$VAR"|tr "\n" "@")/g;s/@/\n/g" /home/vagrant/.config/awesome/rc.lua

read -r -d '' VAR <<-'EOF'
	awful.key({ modkey,           }, "a",
        function ()
        awful.util.spawn("konsole -name menu -e bash -c 'cmd=bash /vagrant_data/shs/list.sh; setsid -f $cmd'")
        end,
        {description = "audio", group = "client"}),
EOF
sudo sed -i "s#Layout manipulation#Layout manipulation@$(echo "$VAR"|tr "\n" "@")#g;s#@#\n#g" /home/vagrant/.config/awesome/rc.lua

read -r -d '' VAR <<-'EOF'
	awful.key({ modkey, "Shift"          }, "a",
        function ()
        awful.util.spawn_with_shell("killall vlc; vlc --qt-start-minimized --rate 1.5  $(cat /tmp/vlcnow.txt)")
        end,
        {description = "audio", group = "client"}),
EOF
sudo sed -i "s#Layout manipulation#Layout manipulation@$(echo "$VAR"|tr "\n" "@")#g;s#@#\n#g" /home/vagrant/.config/awesome/rc.lua


read -r -d '' VAR <<-'EOF'
  { rule = { class = "netease-cloud-music" },
      properties = { minimized = true, tag="E" } },
         { rule = { class = "GoldenDict" },
      properties = { minimized = true, tag="D" } },
EOF
sudo sed -i "s#Add titlebars to normal clients and dialogs#Add titlebars to normal clients and dialogs@$(echo "$VAR"|tr "\n" "@")#g;s#@#\n#g" /home/vagrant/.config/awesome/rc.lua



read -r -d '' VAR <<-'EOF'
	awful.key({ modkey,          }, "d",
        function ()
        awful.util.spawn_with_shell("konsole -name menu -e bash -c 'cmd=bash /vagrant_data/shs/dict.sh; setsid -f $cmd'")
        end,
        {description = "dict", group = "client"}),
EOF
sudo sed -i "s#Layout manipulation#Layout manipulation@$(echo "$VAR"|tr "\n" "@")#g;s#@#\n#g" /home/vagrant/.config/awesome/rc.lua

read -r -d '' VAR <<-'EOF'
	awful.key({ modkey,          }, "e",
        function ()
        awful.util.spawn_with_shell("konsole -name menu -e bash -c 'cmd=bash /vagrant_data/shs/books.sh; setsid -f $cmd'")
        end,
        {description = "books", group = "client"}),
EOF
sudo sed -i "s#Layout manipulation#Layout manipulation@$(echo "$VAR"|tr "\n" "@")#g;s#@#\n#g" /home/vagrant/.config/awesome/rc.lua

read -r -d '' VAR <<-'EOF'
 wibox.container.margin(awful.widget.watch('bash -c "cat /tmp/words.txt | shuf | tail -n 1"', 10,function(widget,stdout)
                 for line in stdout:gmatch(".+") do
                     math.randomseed(os.time())
                     array = {"red", "pink", "yellow"}
                     index_int = math.ceil((math.random()*1000 % #array))
                     widget:set_markup('<span color="' .. array[index_int] .. '">' .. line .. '</span>')
                 end
             end), 20),
EOF
sudo sed -i "s!mykeyboardlayout,!--mykeyboardlayout,@$(echo "$VAR"|tr "\n" "@")!g;s!@!\n!g" /home/vagrant/.config/awesome/rc.lua

read -r -d '' VAR <<-'EOF'
firefox_launcher  = awful.widget.launcher({ image = "/usr/share/icons/hicolor/48x48/apps/firefox.png", command = "firefox", spacing = 10 })    
konsole_launcher  = awful.widget.launcher({ image = "/usr/share/icons/gnome/48x48/apps/utilities-terminal.png", command = "konsole" , spacing = 10})    
thunar_launcher  = awful.widget.launcher({ image = "/usr/share/icons/elementary-xfce/apps/48/Thunar.png", command = "thunar" , spacing = 10})    
shutdown_launcher  = awful.widget.launcher({ image = "/usr/share/icons/elementary-xfce-darker/actions/48/system-shutdown.png", command = "shutdown -h now" , spacing = 10})    
lock_launcher  = awful.widget.launcher({ image = "/usr/share/icons/elementary-xfce/actions/48/lock.png", command = "xfce4-screensaver-command  -l" , spacing = 10}) 
EOF
sudo sed -i "s!Menubar configuration!Menubar configuration@$(echo "$VAR"|tr "\n" "@")!g;s!@!\n!g" /home/vagrant/.config/awesome/rc.lua


read -r -d '' VAR <<-'EOF'
firefox_launcher,
konsole_launcher,
thunar_launcher,
shutdown_launcher,
lock_launcher,
EOF
sudo sed -i "s!mylauncher,!mylauncher,@$(echo "$VAR"|tr "\n" "@")!g;s!@!\n!g" /home/vagrant/.config/awesome/rc.lua

read -r -d '' VAR <<-'EOF'
 style = {
                border_width = 3,
                border_color = '#000',
                shape = gears.shape.hexagon
        },
        layout = {
            spacing = 1,
            spacing_widget = {
                {forced_width = 0, widget = wibox.widget.separator},
                valign = 'right',
                halign = 'center',
                widget = wibox.container.place
            },
            layout = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    {
                        {id = 'icon_role', widget = wibox.widget.imagebox},
                        margins = 0,
                        widget = wibox.container.margin
                    },

                    {id = 'text_role', widget = wibox.widget.textbox},
                    layout = wibox.layout.fixed.horizontal
                },
                left = 20,
                right = 20,
                widget = wibox.container.margin
            },
            id = 'background_role',
            forced_width = 200,
            widget = wibox.container.background
        },
EOF
sudo sed -i "s!currenttags,!currenttags,@$(echo "$VAR"|tr "\n" "@")!g;s!@!\n!g" /home/vagrant/.config/awesome/rc.lua


sudo sed -i 's!theme.bg_normal     = "#222222"!theme.bg_normal     = "#535d6c"!g' /usr/share/awesome/themes/default/theme.lua
sudo sed -i 's!theme.bg_focus      = "#535d6c"!theme.bg_focus      = "#242e30"!g' /usr/share/awesome/themes/default/theme.lua


sudo sed -i 's!theme.bg_systray    = theme.bg_normal .. 50!theme.bg_systray    = theme.bg_normal!g' /usr/share/awesome/themes/default/theme.lua
sudo sed -i 's!theme.bg_systray    = theme.bg_normal!theme.bg_systray    = theme.bg_normal .. 50!g' /usr/share/awesome/themes/default/theme.lua
sudo sed -i 's!theme.font          = "sans 8"!theme.font          = "JetBrainsMono Nerd Font Mono 12"!g' /usr/share/awesome/themes/default/theme.lua
sudo sed -i 's!theme.fg_focus      = "#ffffff"!theme.fg_focus      = "#00ffef"!g' /usr/share/awesome/themes/default/theme.lua


#golden
sudo sed -i 's/enabled="1"/enabled="0"/g' /home/vagrant/.goldendict/config
sudo sed -i 's#<paths/>#<paths><path recursive="1">/vagrant_data/dict/En-En_OALD8</path></paths>#g' /home/vagrant/.goldendict/config
sudo sed -i 's#<hunspell dictionariesPath=""/>#<hunspell dictionariesPath="/vagrant_data/dict/en_US_1.0"><enabled>en_US</enabled></hunspell>#g' /home/vagrant/.goldendict/config
sudo sed -i 's#<useInternalPlayer>1#<useInternalPlayer>0#g' /home/vagrant/.goldendict/config
sudo sed -i 's#<audioPlaybackProgram>mplayer#<audioPlaybackProgram>ffplay -nodisp -autoexit#g' /home/vagrant/.goldendict/config



function k8s_ins(){
	#docker
	if ! dpkg -l | grep -q "docker-ce" ; then
		sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
		sudo curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
		sudo add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
		sudo apt update
		sudo apt-get -y install docker-ce
	fi


	if ! dpkg -l | grep -q "kubectl" ; then
		sudo apt-get update && sudo apt-get install -y apt-transport-https
		sudo curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo  apt-key add - 
		cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
		deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
		sudo apt-get update
		sudo apt-get install -y kubelet kubeadm kubectl
	fi
}



sudo rm -rf /home/vagrant/.local/share/konsole
sudo rm -rf /home/vagrant/.config/konsolerc
sudo cp -r /vagrant_data/conf/konsole/konsole  /home/vagrant/.local/share/konsole
sudo cp /vagrant_data/conf/konsole/konsolerc  /home/vagrant/.config/konsolerc

sudo  locale-gen zh_CN.UTF-8

sudo im-config -n fcitx

if ! dpkg -l | grep -q "sogoupinyin" ; then
	sudo  wget 'http://cdn2.ime.sogou.com/dl/index/1599192613/sogoupinyin_2.3.2.07_amd64-831.deb?st=1cXIZ9xRzyq4GPkctOsB3Q&e=1602396489&fn=sogoupinyin_2.3.2.07_amd64-831.deb' -O sougou.deb && \
       sudo dpkg -i sougou.deb ||   sudo apt-get install -fy  && sudo rm -f sougou.deb

fi

sudo killall fcitx
sudo sed -i 's#sogoupinyin:False#sogoupinyin:True#g'  /home/vagrant/.config/fcitx/profile
sudo sed -i 's#fcitx-keyboard-us:True#fcitx-keyboard-us:False#g' /home/vagrant/.config/fcitx/profile

sudo sed -i '$a\awful.util.spawn("fcitx &")' /home/vagrant/.config/awesome/rc.lua


if ! dpkg -l | grep -q "netease" ; then
	sudo  wget 'https://d1.music.126.net/dmusic/netease-cloud-music_1.2.1_amd64_ubuntu_20190428.deb' -O netease.deb && \
        sudo gdebi -n netease.deb  && sudo rm -f netease.deb
fi

if ! dpkg -l | grep -q "baidunetdisk" ; then
	sudo  wget 'https://issuecdn.baidupcs.com/issue/netdisk/LinuxGuanjia/3.5.0/baidunetdisk_3.5.0_amd64.deb' -O baiduyun.deb && \
        sudo gdebi -n baiduyun.deb  && sudo rm -f baiduyun.deb
        sudo ln -s /opt/baidunetdisk/baidunetdisk /usr/bin/baidunetdisk
fi


sudo -H -u vagrant bash /vagrant_data/shs/zsh.sh

# vim 
sudo -H -u vagrant bash /vagrant_data/shs/neovim.sh 
