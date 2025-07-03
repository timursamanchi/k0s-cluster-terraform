#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -e

sleep 10
touch /tmp/it-worked
echo "Create k8 controllers and installing apps: $(date '+%Y-%m-%d %H:%M:%S') - check /var/log/user-data" > /tmp/k8-welcome.txt

# Disable swap
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Install base packages
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release

# Install kubectl from official binary
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install k0s
curl -sSLf https://get.k0s.sh | sudo sh
systemctl enable --now k0scontroller
