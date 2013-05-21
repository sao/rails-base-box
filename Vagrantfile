Vagrant.configure("2") do |config|
  config.vm.box       = "precise32"
  config.vm.box_url   = "http://files.vagrantup.com/precise32.boxr"
  config.vm.hostname = "rails-base-box"
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", "512"]
    v.customize ["modifyvm", :id, "--cpus", "2"]
  end

  config.vm.synced_folder ".", "/vagrant", :nfs => true

  config.vm.network :private_network, ip: "192.168.50.4"
  config.vm.network :forwarded_port, host: 8080, guest: 8080
  config.vm.network :forwarded_port, host: 3000, guest: 3000
  config.vm.network :forwarded_port, host: 6379, guest: 6379
  config.vm.network :forwarded_port, host: 6900, guest: 6900

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path    = "puppet/modules"
  end
end
