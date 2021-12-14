# Verify that libvirt is installed correctly
REQUIRED_PLUGINS_LIBVIRT = %w(vagrant-libvirt)
exit unless REQUIRED_PLUGINS_LIBVIRT.all? do |plugin|
  Vagrant.has_plugin?(plugin) || (
    puts "The #{plugin} plugin is required. Please install it with:"
    puts "$ vagrant plugin install #{plugin}"
    false
  )
end

# Base image for all gameserver VMs
IMAGE_NAME = "generic/ubuntu2004"

gameservers = {
  "factorio" => {
    :cpus => 2, 
    :memory => 8196,
    :ip => "10.0.0.252",
    :bootstart => false
  },
  "minecraft" => {
    :cpus => 2, 
    :memory => 4096,
    :ip => "10.0.0.251",
    :bootstart => false
  },
  "satisfactory" => {
    :cpus => 4, 
    :memory => 12288,
    :ip => "10.0.0.250",
    :bootstart => true
  },
  "valheim" => {
    :cpus => 2, 
    :memory => 4096,
    :ip => "10.0.0.253",
    :bootstart => false
  },
}

Vagrant.configure("2") do |config|

  gameservers.each_with_index do |(gameserver, spec), index|

    config.vm.define gameserver do |gs|
      gs.vm.box = IMAGE_NAME
      gs.vm.hostname = gameserver

      gs.env.enable # fetch variables from .env file
      gs.vm.synced_folder "./.backups/#{gameserver}", "/home/vagrant/backups", create: true

      gs.ssh.forward_agent = false # Do not re-use SSH key pair from host machine
      gs.vm.network :public_network,
        :dev => "br0",
        :mode => "virtio",
        :type => "bridge",
        ip: spec[:ip],
        auto_config: true

      gs.vm.provider :libvirt do |libvirt|
        libvirt.autostart = spec[:bootstart]
        libvirt.cpu_mode = "host-passthrough" # The L3 cache for the guest will only be exposed if set to "host-passthrough"
        libvirt.cpus = spec[:cpus]
        libvirt.disk_driver :cache => "writeback", :io => "threads" # Significantly increase guest I/O speed, as disk R/W is cached in the host memory pool. Only use aio=native on only fully preallocated volumes.
        libvirt.driver = "kvm"
        libvirt.graphics_type = "none"
        libvirt.memory = spec[:memory]
        libvirt.sound_type = nil
        libvirt.video_type = "none"
        libvirt.video_vram = "0"
      end

      gs.vm.provision "playbook-core", type:'ansible' do |ansible|
        ansible.compatibility_mode = "2.0"
        ansible.config_file = "ansible/ansible.cfg"
        ansible.playbook = "ansible/ubuntu-base.yml" 
      end

      gs.vm.provision "playbook-gameserver", type:'ansible' do |ansible|
        ansible.compatibility_mode = "2.0"
        ansible.config_file = "ansible/ansible.cfg"
        ansible.playbook = "ansible/#{gameserver}.yml"
        ansible.extra_vars = {
          discord_webhook: ENV['DISCORD_WEBHOOK'],
        }
      end
    end
  end
end
