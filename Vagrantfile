Vagrant::Config.run do |config|
  config.vm.box       = 'precise32'
  config.vm.box_url   = 'http://files.vagrantup.com/precise32.box'
  config.vm.host_name = 'rails-dev-box'
  config.vm.customize ["modifyvm", :id, "--memory", 512]

  config.vm.network :hostonly, "33.33.0.10"
  config.vm.share_folder("v-root", "/vagrant", ".", :nfs => true)

  config.vm.forward_port 3000, 3000

  config.vm.provision :puppet,
    :manifests_path => 'puppet/manifests',
    :module_path    => 'puppet/modules',
    :options        => %w[ --libdir=\\$modulepath/rbenv/lib ]
end
