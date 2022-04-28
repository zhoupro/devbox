source ./basesoft.sh
source ./nodejs.sh

#w2
if [ ! -f /usr/local/bin/w2 ];then
     /usr/local/lib/nodejs/node/bin/npm install whistle -g --registry=https://registry.npm.taobao.org
     ln -s  /usr/local/lib/nodejs/node/bin/w2 /usr/local/bin/w2
fi

 /usr/local/lib/nodejs/node/bin/w2 start > /dev/null
if [ -f $HOME/.WhistleAppData/.whistle/properties/properties ];then
    if ! grep interceptHttpsConnects $HOME/.WhistleAppData/.whistle/properties/properties ;then
        sed -i 's#{#{"interceptHttpsConnects":true,#g' $HOME/.WhistleAppData/.whistle/properties/properties
    fi
    sed -i 's#"interceptHttpsConnects":false#"interceptHttpsConnects":true#g' $HOME/.WhistleAppData/.whistle/properties/properties
fi

 /usr/local/lib/nodejs/node/bin/w2 restart > /dev/null
 /usr/local/lib/nodejs/node/bin/w2 add /vagrant_data/conf/.whistle.js --force