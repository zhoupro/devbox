#lantern
if (( $(dpkg -l | awk '{print $2}' | grep ^lantern | wc -l)==0 )) ;then

    if [ ! -f /vagrant_data/soft/lantern.deb ];then
      axel -n 50 -o /vagrant_data/soft/lantern.deb 'https://s3.amazonaws.com/lantern/lantern-installer-64-bit.deb'
    fi
     gdebi -n /vagrant_data/soft/lantern.deb 
    
 fi

if [  -f ~/.lantern/settings.yaml ] ;then
      # config replace
       sed -i 's/addr.*/addr : 0\.0\.0\.0:8087/g' ~/.lantern/settings.yaml
       sed -i 's/uiAddr.*/uiAddr : 0\.0\.0\.0:8080/g' ~/.lantern/settings.yaml
fi