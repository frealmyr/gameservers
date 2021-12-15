#!/bin/bash

echo ""
echo "apt: update & upgrade.."
sudo apt update && sudo apt upgrade -f

echo ""
echo "apt: install packages.."
sudo apt install -y curl

echo ""
echo "apt: add vagrant repository"
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sleep 2
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sleep 2

echo ""
echo "apt: update and install vagrant.."
sudo apt update
sudo apt install -y ansible vagrant

echo ""
echo "apt: install qemu kvm.."
sudo apt install -y build-essential qemu qemu-kvm libvirt-clients libvirt-daemon-system virtinst bridge-utils

echo ""
echo "systemd: enable and start libvirtd"
sudo systemctl enable libvirtd
sudo systemctl start libvirtd
systemctl status libvirtd

echo ""
echo "apt: installing libvirt.."
sudo apt-get install -y qemu libvirt-daemon-system libvirt-clients libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev ruby-libvirt ebtables dnsmasq-base

echo ""
echo "vagrant: installing plugins.."
vagrant plugin install vagrant-libvirt
vagrant plugin install vagrant-env

echo ""
echo "nmcli: creating network bridge on enp2s0.."
sudo nmcli conn add type bridge con-name br0 ifname br0 \
  && sudo nmcli conn add type ethernet slave-type bridge con-name bridge-br0 ifname enp2s0 master br0

echo ""
echo "nmcli: creating network bridge on enp3s0.."
sudo nmcli conn add type bridge con-name br1 ifname br1 \
  && sudo nmcli conn add type ethernet slave-type bridge con-name bridge-br1 ifname enp3s0 master br1

echo ""
echo "nmcli: switching to bridged network.."
sudo nmcli conn up br0 \
  && sudo nmcli conn down Wired\ connection\ 1 \
  && sudo nmcli conn up br1 \
  && sudo nmcli conn down Wired\ connection\ 2 \
  && sudo nmcli conn show --active
