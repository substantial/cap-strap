Vagrant::Config.run do |config|

  config.vm.box = "lucid64"

  config.vm.box_url = "http://files.vagrantup.com/lucid64.box"

  config.vm.forward_port 80, 8080
  config.vm.forward_port 22, 2222
  config.ssh.forward_agent = true
end
