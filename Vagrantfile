ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure("2") do |config|
  config.vm.provision "shell", path: "bootstrap.sh"
  # k8s master server
  config.vm.define "kmaster" do |node|
    node.vm.box               = "ubuntudesktop2004"
    node.vm.box_check_update  = false
    node.vm.hostname          = "kmaster.example.com"
    node.vm.network "private_network", ip: "172.16.16.100"
    config.vm.synced_folder "./share", "/vagrant_data"
    config.ssh.username = "vagrant"
    config.ssh.password = "vagrant"
    node.vm.provider :virtualbox do |v|
      v.gui = true
      v.name    = "kmaster"
      v.memory  = 4096 
      v.cpus    =  4
    end
  end

  # Kubernetes Worker Nodes
  NodeCount = 0
  (1..NodeCount).each do |i|
    config.vm.define "kworker#{i}" do |node|
      node.vm.box               = "ubuntudesktop2004"
      node.vm.box_check_update  = false
      node.vm.hostname          = "kworker#{i}.example.com"
      node.vm.network "private_network", ip: "172.16.16.10#{i}"
      config.vm.synced_folder "./share", "/vagrant_data"
      config.ssh.username = "vagrant"
      config.ssh.password = "vagrant"
      node.vm.provider :virtualbox do |v|
        v.name    = "kworker#{i}"
        v.memory  = 1024
        v.cpus    = 1
      end
    end
  end
end
