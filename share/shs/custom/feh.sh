#!/bin/bash 

source /vagrant_data/shs/custom/size.sh

if size;then
	feh --bg-fill --no-fehbg --randomize /vagrant_data/background/vertical &
else
	feh --bg-fill --no-fehbg --randomize /vagrant_data/background/horizal &
fi
