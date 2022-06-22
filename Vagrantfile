#ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure("2") do |config|
  config.vm.provision "shell", path: "share/bootstraps/base.sh"
  # master server
  config.vm.define "kmaster" do |node|
    node.vm.box               = "xubuntu20_04"
    node.vm.box_check_update  = false
    node.vm.hostname          = "kmaster.example.com"
    node.vm.network "private_network", ip: "192.168.56.100"
    config.vm.synced_folder "./share", "/vagrant_data"
    config.vm.synced_folder "./disk", "/vagrant_disk"
    #config.vm.synced_folder "C:\\Users\\zhoupro\\.ssh", "/root/.ssh"
    config.ssh.username = "vagrant"
    config.ssh.password = "vagrant"
    config.ssh.insert_key = false
    node.vm.provider :virtualbox do |v|
      v.gui = true
      v.name    = "kmaster"
      v.memory  =  8096 
      v.cpus    =  4
    end
    node.vm.provision "shell", path: "share/shs/zsh.sh"
    node.vm.provision "shell", path: "share/shs/devbase.sh"
    node.vm.provision "shell", path: "share/shs/tmux.sh"
    node.vm.provision "shell", path: "share/shs/alacritty.sh"
    node.vm.provision "shell", path: "share/shs/awesome.sh"
    node.vm.provision "shell", path: "share/shs/dockerenv.sh"
    node.vm.provision "shell", path: "share/shs/neovim_base_packer.sh"
    node.vm.provision "shell", path: "share/shs/neovim_c.sh"
    node.vm.provision "shell", path: "share/shs/neovim_php.sh"
    node.vm.provision "shell", path: "share/shs/neovim_go.sh"
    node.vm.provision "shell", path: "share/shs/write.sh"
    node.vm.provision "shell", path: "share/shs/after.sh"
    node.vm.provision "shell", path: "share/shs/goldendict.sh"
  end

  # Kubernetes Worker Nodes
  NodeCount = 0
  (1..NodeCount).each do |i|
    config.vm.define "kworker#{i}" do |node|
      node.vm.box               = "xubuntu20_04"
      node.vm.box_check_update  = false
      node.vm.hostname          = "kworker#{i}.example.com"
      node.vm.network "private_network", ip: "192.168.56.10#{i}"
      config.vm.synced_folder "./share", "/vagrant_data"
      config.ssh.username = "vagrant"
      config.ssh.password = "vagrant"
      config.ssh.insert_key = false
      node.vm.provider :virtualbox do |v|
        v.gui = false
        v.name    = "kworker#{i}"
        v.memory  = 1024
        v.cpus    = 1
     end
    end
  end
end