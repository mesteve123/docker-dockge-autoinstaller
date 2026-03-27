#!/bin/bash

set -e

echo "========================================="
echo " Autoinstaller Docker and Dockge on Ubuntu"
echo "========================================="

# Comprobar si se ejecuta como root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root"
  exit 1
fi

echo "Installing dependencies..."
apt install ca-certificates curl gnupg lsb-release -y

echo "Creating a keyring directory..."
mkdir -m 0755 -p /etc/apt/keyrings

echo "Downloading Docker GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "Adding official Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Updating repositories..."
apt update

echo "Installing Docker..."
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

echo "Creating Dockge  folders..."
mkdir -p /opt/stacks /opt/dockge

echo "Deploying Dockge ..."
curl https://raw.githubusercontent.com/louislam/dockge/master/compose.yaml --output /opt/dockge/compose.yaml
OLDPWD=$(pwd)
cd /opt/dockge
docker compose up -d
cd "$OLDPWD"

rm install_docker_dockge.sh

IP=$(hostname -I | awk '{print $1}')

clear

echo "========================================="
echo " Autoinstaller Docker and Dockge on Ubuntu"
echo "========================================="
echo "Installation completed successfully"
echo "Dockge is accessible at:"
echo "http://$IP:5001"
echo "========================================="

