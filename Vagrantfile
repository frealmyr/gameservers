REQUIRED_PLUGINS_LIBVIRT = %w(vagrant-libvirt)
exit unless REQUIRED_PLUGINS_LIBVIRT.all? do |plugin|
  Vagrant.has_plugin?(plugin) || (
    puts "The #{plugin} plugin is required. Please install it with:"
    puts "$ vagrant plugin install #{plugin}"
    false
  )
end

IMAGE_NAME = "generic/ubuntu2004"

gameservers = {
  "satisfactory" => {
    :cpus => 6, 
    :memory => 12800,
    :ip => "10.0.0.250"
  },
  "minecraft" => {
    :cpus => 2, 
    :memory => 4196,
    :ip => "10.0.0.251"
  },
}

Vagrant.configure("2") do |config|

  gameservers.each_with_index do |(gameserver, spec), index|

    config.vm.define gameserver do |gs|
      gs.vm.box = IMAGE_NAME
      gs.vm.hostname = gameserver
      gs.ssh.forward_agent = false
      gs.vm.network :public_network,
        :dev => "br0",
        :mode => "virtio",
        :type => "bridge",
        ip: spec[:ip],
        auto_config: true

      gs.vm.provider "libvirt" do |libvirt|
        libvirt.driver = "kvm"
        libvirt.cpus = spec[:cpus]
        libvirt.memory = spec[:memory]
        libvirt.graphics_type = "none"
      end

      gs.vm.provision "playbook-core", type:'ansible' do |ansible|
        ansible.config_file = "ansible/ansible.cfg"
        ansible.playbook = "ansible/ubuntu-base.yml" 
      end

      gs.vm.provision "playbook-gameserver", type:'ansible' do |ansible|
        ansible.config_file = "ansible/ansible.cfg"
        ansible.playbook = "ansible/#{gameserver}.yml"
      end
    end
  end
end
