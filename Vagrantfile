# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vm.box = "westlife-eu/scientific_7_gui"

  config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
     vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
     vb.memory = "4096"
     vb.cpus = "2"
     vb.customize ["modifyvm", :id, "--vram", "128"]
  end
 
  puts "vagrant version:"
  puts Vagrant::VERSION
  config.vm.provision "shell",  path: "./scripts/bootstrap.sh"
  config.vm.provision "shell",  path: "./scripts/bootstrapjupyter.sh"
  config.vm.provision "shell",  path: "./scripts/bootstrapopenmodelica.sh"
  config.vm.provision "shell",  path: "./scripts/bootstrapbodylight.sh"
  # config.vm.provision "shell",  path: "./scripts/bootstrapjulia.sh"
  config.vm.provision "shell",  path: "./scripts/bootstrapservices.sh"
  # config.vm.provision "shell",  path: "./scripts/bootstrapjuliaservices.sh"
  config.vm.synced_folder ".", "/vagrant"
  # vagrant data mapping is mapped up to one parent (..) 
  # uncomment next row and comment row bellow to map up to 2 parent directories (../..) 
  # config.vm.synced_folder "../..", "/vagrant_data"
  config.vm.synced_folder "..", "/vagrant_data"
end
