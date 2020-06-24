IMAGE_NAME = "ubuntu/xenial64"
N = 2

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
  end
      
  config.vm.define "k8s-master" do |master|
    master.vm.box = IMAGE_NAME
    master.vm.network "private_network", ip: "192.168.50.10"
    master.vm.hostname = "k8s-master"
    if Vagrant.has_plugin?("vagrant-hosts")
      master.vm.provision :hosts, :sync_hosts => true
    end
    master.vm.provision "ansible_local" do |ansible|
      ansible.compatibility_mode = "2.0"
      ansible.playbook = "kubernetes-setup/master-playbook.yml"
      ansible.pip_install_cmd = "curl https://bootstrap.pypa.io/get-pip.py | sudo python3"
      ansible.install_mode = "pip"
      # Install desired ansible version (default = latest)
      # ansible.version = "2.9.6"
      ansible.extra_vars = {
        ansible_python_interpreter: '/usr/bin/python3',
        node_ip: "192.168.50.10"
      }
    end
    master.vm.provider "virtualbox" do |vb|
      vb.name = "k8s-master"
    end
    master.vm.synced_folder "k8s-files", "/home/vagrant/k8s-files", type: "rsync"
    master.vm.provision "shell", privileged: true, path: "provision/helm.sh"
  end

  (1..N).each do |i|
    config.vm.define "k8s-node-#{i}" do |node|
      node.vm.box = IMAGE_NAME
      node.vm.network "private_network", ip: "192.168.50.#{i + 10}"
      node.vm.hostname = "k8s-node-#{i}"
      if Vagrant.has_plugin?("vagrant-hosts")
        node.vm.provision :hosts, :sync_hosts => true
      end
      node.vm.provision "ansible_local" do |ansible|
        ansible.compatibility_mode = "2.0"
        ansible.playbook = "kubernetes-setup/node-playbook.yml"
        ansible.pip_install_cmd = "curl https://bootstrap.pypa.io/get-pip.py | sudo python3"
        ansible.install_mode = "pip"
        # Install desired ansible version (default = latest)
        # ansible.version = "2.9.6"
        ansible.extra_vars = {
          ansible_python_interpreter: '/usr/bin/python3',
          node_ip: "192.168.50.#{i + 10}"
        }
      end
      node.vm.provider "virtualbox" do |vb|
        vb.name = "k8s-node-#{i}"
      end
    end
  end

end