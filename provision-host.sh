#!/bin/bash

echo "apt: update & upgrade.."
sudo apt update && sudo apt upgrade -f

echo "apt: installing vagrant, qemu and libvirt.."
sudo apt install -f ansible vagrant qemu-kvm libvirt-daemon-system qemu-utils libvirt-dev ruby-dev

echo "nmcli: creating network bridge on enp2s0.."
sudo nmcli conn add type bridge con-name br0 ifname br0 \
  && sudo nmcli conn add type ethernet slave-type bridge con-name bridge-br0 ifname enp2s0 master br0 \
  && sudo nmcli conn up br0 \
  && sudo nmcli conn down Wired\ connection\ 1 \
  && sudo nmcli conn show --active