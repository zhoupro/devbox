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
    config.ssh.username = "vagrant"
    config.ssh.password = "vagrant"
    config.ssh.insert_key = false
    node.vm.provider :virtualbox do |v|
      v.gui = true
      v.name    = "kmaster"
      v.memory  =  4096 
      v.cpus    =  2
    end
    node.vm.provision "shell", path: "share/shs/zsh.sh"
    node.vm.provision "shell", path: "share/shs/devbase.sh"
    node.vm.provision "shell", path: "share/shs/awesome.sh"
    node.vm.provision "shell", path: "share/shs/dockerenv.sh"
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