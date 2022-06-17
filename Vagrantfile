Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", ip: "192.168.33.11"
  config.vm.network "forwarded_port", guest: 22, host: 6012
  config.vm.hostname = "avni-ubuntu"
end
