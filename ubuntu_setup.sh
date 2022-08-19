#!/bin/bash

# Finish early if user hasn't got sudoer privileges
command -v sudo &> /dev/null && sudo -v
[[ $(id -u) != 0 ]] && exit 0

# Variables
arch=$(dpkg --print-architecture)
codename=$(lsb_release -cs)
keyring_path=/usr/share/keyrings

# Install updates and basic packages
sudo apt-get update -qq \
  && sudo apt-get upgrade -qq -y \
  && sudo apt-get install -qq -y \
    ca-certificates \
    curl \
    git \
    gnupg \
    lsb-release

# Install Docker and Containerd if necessary
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
# Swappines (https://www.mongodb.com/docs/manual/administration/production-notes/#std-label-set-swappiness)
if grep -q '^vm.swappiness' /etc/sysctl.conf ; then
  sudo sed -i '/^vm.swappiness/c\vm.swappiness=1' /etc/sysctl.conf
else
  echo -en '\nvm.swappiness=1\n' | sudo tee --append /etc/sysctl.conf > /dev/null
fi
sudo sysctl -p

# Unset variables
unset arch codename keyring_path

# Expire root privileges
sudo -k
