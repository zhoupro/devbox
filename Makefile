clean:
	echo "clean"; vagrant destroy ; rm -rf .vagrant

up:
	echo "up"; vagrant up --no-provision ; vagrant provision

restart:
	echo "restart";vagrant reload
