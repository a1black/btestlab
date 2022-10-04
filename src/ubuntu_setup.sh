#!/bin/bash

# Finish early if user hasn't got root privileges
[[ $(id -u) != 0 ]] && echo 'Run script with root privileges.' && exit 1

# Install updates and basic packages
apt-get update -qq \
  && apt-get upgrade -qq -y \
  && apt-get install -qq -y \
    apt-transport-https \
    ca-certificates \
    curl \
    git \
    gnupg \
    lsb-release

# Variables
arch=$(dpkg --print-architecture)
codename=$(lsb_release -cs)
keyring_path=/usr/share/keyrings

# Install Docker and Containerd
if command -v docker &> /dev/null ; then
  sudo mkdir -p $keyring_path \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
      sudo gpg --dearmor -o $keyring_path/docker.gpg \
    && sudo chmod a+r $keyring_path/docker.gpg \
    && echo "deb [arch=$arch signed-by=$keyring_path/docker.gpg] \
        https://download.docker.com/linux/ubuntu $codename stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && sudo apt-get update -qq \
    && sudo apt-get install -qq -y \
      docker-ce \
      docker-ce-cli \
      containerd.io \
      docker-compose-plugin
fi

# Apply recommended system settings
# UFW
if read -n 1 -sp 'Add ufw rules for the RFC1918 networks? [y/N]: ' ufwadd && [[ ${ufwadd,,} == 'y' ]]; then
  ufw allow proto tcp from 10.0.0.0/8 to any port 80,443 &> /dev/null
  ufw allow proto tcp from 172.16.0.0/12 to any port 80,443 &> /dev/null
  ufw allow proto tcp from 192.168.0.0/16 to any port 22,80,443 &> /dev/null
  echo -e '\nFarewall rules updated'
else
  echo ''
fi

# Swappines (https://www.mongodb.com/docs/manual/administration/production-notes/#std-label-set-swappiness)
if grep -q '^vm.swappiness' /etc/sysctl.conf ; then
  sed -i '/^vm.swappiness/c\vm.swappiness=1' /etc/sysctl.conf
else
  echo 'vm.swappiness=1' >> /etc/sysctl.conf
fi
sysctl -p

# vi: et ts=2 sw=2