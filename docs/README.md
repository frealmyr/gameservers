# Gameservers

> Better documentation coming soon~

This repository uses Vagrant and Ansible to create and provision VMs for different gameservers.

* Uses nmcli to create a network bride on enp2s0 (eth0) adapter.
* Creates qemu VMs with virtio bridged network adapter, which gives VMs a individual IP on local network.
* Provisions VMs with Ansible script, one base and another specific for the gameserver.

## Discord Alerts

Create a `.env` file with the following:
```bash
DISCORD_WEBHOOK=<paste webhook here>
```

The webhook is only added during provision. To change it after provisioning you would need to edit it manually in `/home/vagrant/lgsm/config-lgsm/*/common.cfg`