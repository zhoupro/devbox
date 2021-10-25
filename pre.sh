sudo apt-get update
sudo apt-get install linux-headers-$(uname -r) build-essential dkms
sudo mount /dev/cdrom /mnt
cd /mnt
sudo ./VBoxLinuxAdditions.run
sudo usermod -aG vboxsf vagrant

sudo add-apt-repository -y  ppa:jonathonf/vim
sudo apt update
sudo apt install vim
sudo apt install openssh-server
sudo update-alternatives --config editor
echo "vagrant ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

vagrant package --base ubuntu1804 --output ubuntu1804.box
vagrant box add ./ubuntu1804.box --name ubuntu1804


