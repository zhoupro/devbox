#!/bin/bash
sudo  apt-get install -y    goldendict ffmpeg xfce4-clipman
rm -rf  /home/vagrant/.goldendict/config && mkdir -p /home/vagrant/.goldendict && \
cp /vagrant_data/conf/goldendict/config  /home/vagrant/.goldendict/config

#golden
sudo sed -i 's/enabled="1"/enabled="0"/g' /home/vagrant/.goldendict/config
sudo sed -i 's#<paths/>#<paths><path recursive="1">/vagrant_data/dict/En-En_OALD8</path></paths>#g' /home/vagrant/.goldendict/config
sudo sed -i 's#<hunspell dictionariesPath=""/>#<hunspell dictionariesPath="/vagrant_data/dict/en_US_1.0"><enabled>en_US</enabled></hunspell>#g' /home/vagrant/.goldendict/config
sudo sed -i 's#<useInternalPlayer>1#<useInternalPlayer>0#g' /home/vagrant/.goldendict/config
sudo sed -i 's#<audioPlaybackProgram>mplayer#<audioPlaybackProgram>ffplay -nodisp -autoexit#g' /home/vagrant/.goldendict/config
