source ./basesoft.sh

#sogou
if (( $(dpkg -l | awk '{print $2}' | grep ^sogou | wc -l)==0 )) ;then
    if [ ! -f /vagrant_data/soft/sogou.deb ];then
      axel -n 40 -o /vagrant_data/soft/sogou.deb 'http://cdn2.ime.sogou.com/dl/index/1599192613/sogoupinyin_2.3.2.07_amd64-831.deb?st=1cXIZ9xRzyq4GPkctOsB3Q&e=1602396489&fn=sogoupinyin_2.3.2.07_amd64-831.deb'
    fi
     gdebi -n /vagrant_data/soft/sogou.deb 
fi