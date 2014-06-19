# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure("2") do |config|
    config.vm.box = "precise64"
    config.vm.box_url = "http://files.vagrantup.com/precise64.box"
    config.vm.provision :file, :source => ".bashrc", :destination => "/home/vagrant/.bashrc"
    config.vm.provision :file, :source => "pg_hba.conf", :destination => "/vagrant/postgres/pg_hba.conf"
    config.vm.provision :shell, :path => "bootstrap.sh"
    config.vm.synced_folder "/Users/richarms/vm_data", "/data", owner: "vagrant", group: "vagrant"
    config.vm.network "forwarded_port", guest: 8880, host: 8880
    config.ssh.forward_x11 = true
    config.vm.provider "virtualbox" do |v|
        v.memory = 1536
    end
end
