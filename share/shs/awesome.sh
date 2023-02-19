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
sudo apt-get install -y   awesome xfce4
#sudo apt-get install -y   awesome xfce4 ubuntu-desktop
sudo apt-get install -y   rofi    feh xcompmgr  flameshot  x11-apps
mkdir -p $CUSTOM_HOME/.config/awesome
cp /vagrant_data/conf/awesome/fancy_taglist.lua  $CUSTOM_HOME/.config/awesome/fancy_taglist.lua
cp /etc/xdg/awesome/rc.lua $CUSTOM_HOME/.config/awesome/rc.lua

sudo sed -i 's/"Mod4"/"Mod1"/g' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i 's/x-terminal-emulator/alacritty/g' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i 's/mylauncher,/--mylauncher,/g' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i 's/titlebars_enabled = true/titlebars_enabled = false/g' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i '$a\awful.util.spawn("bash /vagrant_data/shs/custom/bingimg.sh")' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i '$a\awful.util.spawn("bash /vagrant_data/shs/custom/feh.sh")' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i '$a\awful.util.spawn("xcompmgr &")' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i '$a\awful.util.spawn("xfce4-volumed &")' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i '$a\awful.util.spawn("xfce4-power-manager &")' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i '$a\awful.util.spawn("flameshot")' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i '$a\awful.util.spawn("fcitx")' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i '$a\awful.util.spawn("xfce4-clipman")' $CUSTOM_HOME/.config/awesome/rc.lua

sudo sed -i  -E '/awful.layout.suit.fair/,+7{s/(.*)/--\1/}' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i  -E '/awful.layout.suit.floating/{s/(.*)/--\1/}' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i  -E '/Set Firefox/a\ {rule={class="Alacritty"},properties={screen=1, opacity=0.85,switchtotag=true}},' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i  -E '/mykeyboardlayout,/s/(.*)/--\1/' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i  -E '/wibox.widget.textclock/s/textclock\(\)/textclock\("%H:%M %a %m-%d"\)/' $CUSTOM_HOME/.config/awesome/rc.lua

sudo sed -i -E '/Example/a\theme.taglist_font = "JetBrainsMono Nerd Font Mono 8"' /usr/share/awesome/themes/default/theme.lua

sudo sed -i -E '/s.mytaglist,/s/(.*)/--\1/' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i -E '/s.mytasklist,/s/(.*)/--\1/' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i -E '/s.mytasklist,/a\s.mytaglist,' $CUSTOM_HOME/.config/awesome/rc.lua

sudo sed -i -E '/widget\.taglist/,+4s/(.*)/--\1/' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i -E '/systray/s/.*/wibox.container.margin(wibox.widget.systray(),0,0,5,5),/' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i -E '/awful.tag\(/{s/(.*)/--\1/}' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i -E '/for_each_screen/a\
        local fancy_taglist = require("fancy_taglist") \
        s.mytaglist = fancy_taglist.new({\
          screen = s,\
      })\
	 s.mytaglist = wibox.container.margin(s.mytaglist,0,0,5,5)\
     if s.geometry.width >= s.geometry.height then\
         awful.tag({ "1", "2", "3", "4", "5"}, s, awful.layout.layouts[1]) \
    else\
      awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[3])\
    end \
    ' $CUSTOM_HOME/.config/awesome/rc.lua
sudo sed -i -E '/set_wallpaper\)/s/set_wallpaper/awesome.restart/' $CUSTOM_HOME/.config/awesome/rc.lua

sudo sed -i -E '/ {3,}set_wallpaper\(/s/(.*)/--\1/' $CUSTOM_HOME/.config/awesome/rc.lua

sudo sed -i -E '/position =/s/top/bottom/'  $CUSTOM_HOME/.config/awesome/rc.lua

#sudo fsed  'awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])' 'awful.tag({  "1", "2", "3", "4","5"  }, s, awful.layout.layouts[1])'  $CUSTOM_HOME/.config/awesome/rc.lua

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

#sudo sed -i "s!mytextclock,!--mytextclock,!g"  $CUSTOM_HOME/.config/awesome/rc.lua



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
sudo sed -i 's!theme.border_focus  = "#535d6c"!theme.border_focus  = "#755058"!g' /usr/share/awesome/themes/default/theme.lua

sudo sed -i 's!theme.bg_systray    = theme.bg_normal .. 50!theme.bg_systray    = theme.bg_normal!g' /usr/share/awesome/themes/default/theme.lua
sudo sed -i 's!theme.bg_systray    = theme.bg_normal!theme.bg_systray    = theme.bg_normal .. 50!g' /usr/share/awesome/themes/default/theme.lua
sudo sed -i 's!theme.font          = "sans 8"!theme.font          = "JetBrainsMono Nerd Font Mono 12"!g' /usr/share/awesome/themes/default/theme.lua
sudo sed -i 's!theme.fg_focus      = "#ffffff"!theme.fg_focus      = "#00ffef"!g' /usr/share/awesome/themes/default/theme.lua

sudo sed -i -E '/theme.border_width/s/.*/theme.border_width = dpi(1.5)/' /usr/share/awesome/themes/default/theme.lua
sudo sed -i '$ a --END'  $CUSTOM_HOME/.config/awesome/rc.lua

read -r -d '' VAR <<-'EOF'
    gears.timer {
        timeout = 360,
        call_now = false,
        autostart = true,
        callback = function()
            awful.util.spawn("bash /vagrant_data/shs/custom/bingimg.sh")
            awful.util.spawn("bash /vagrant_data/shs/custom/feh.sh")
        end
    }

local function setImg(iconImg, c)
    local cairo = require("lgi").cairo
    local s = gears.surface(iconImg)
    local img = cairo.ImageSurface.create(cairo.Format.ARGB32, s:get_width(),s:get_height())
    local cr = cairo.Context(img)
    cr:set_source_surface(s,0,0)
    cr:paint()
    c.icon = img._native
end


client.connect_signal("property::name", function(c)
    -- naughty.notify({title = c.name})
    if c.class ~= "Alacritty" and c.class ~= "Gnome-terminal" then
        return
    end

    local iconImg = "/usr/share/icons/Numix-Circle/48/apps/Terminal.svg"
    if string.find(c.name, "vim") then
        iconImg = "/usr/share/icons/Numix-Circle/48/apps/neovim.svg"
    end
    setImg(iconImg, c)
end)

EOF

sudo sed -i "s#END#END@$(echo "$VAR"|tr "\n" "@")#g;s#@#\n#g" $CUSTOM_HOME/.config/awesome/rc.lua
