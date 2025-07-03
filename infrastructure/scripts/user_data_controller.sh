#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -e
touch /tmp/it-works
echo "Hello from controller node! July 3" > /tmp/it-works
echo "Installing apps: $(date '+%Y-%m-%d %H:%M:%S')" >> /tmp/it-worx

# Disable swap
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Install base packages
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release

# Install k0s
curl -sSLf https://get.k0s.sh | sudo sh
k0s default-config > /etc/k0s.yaml
k0s install controller --config /etc/k0s.yaml
# Start k0s controller service after a short pause
sleep 5
systemctl enable --now k0scontroller

# Install kubectl from official binary
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Log kubernetes apps versions
k0s version
kubectl version --client
