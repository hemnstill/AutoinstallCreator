Vagrant.configure("2") do |config|
  config.vm.define "core" do |config|
    config.vm.box = "cdaf/WindowsServerCore"
    config.vm.box_version = "2021.09.15"

    config.winrm.username = "vagrant"
    config.winrm.password = "vagrant"
    config.vm.guest = :windows
    config.vm.communicator = "winrm"
    config.winrm.timeout = 2800 # 30 minutes
    config.winrm.max_tries = 40
    config.winrm.retry_limit = 200
    config.winrm.retry_delay = 10
    config.vm.graceful_halt_timeout = 600

    config.vm.hostname = "winserver"
    config.vm.network "private_network", ip: "192.168.56.2"

    config.vm.provider :virtualbox do |v, override|
      v.memory = 2024
	    v.cpus = 1
	    v.gui = false
    end
  end

  config.vm.box_check_update = false
  config.vm.boot_timeout = 2800
end