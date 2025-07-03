# ----------------------------------------------------
# controller NODE
# ----------------------------------------------------
resource "aws_instance" "controller" {
  count                       = var.node_config["controller"].count
  ami                         = var.node_config["controller"].ami_id
  instance_type               = var.node_config["controller"].instance_type
  key_name                    = aws_key_pair.k0s_key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.k0s_controller_sg.id]
 
 subnet_id = element(
  aws_subnet.controller_priv[*].id,
  count.index % length(aws_subnet.controller_priv)
)

  tags = {
    Name = "k0s-controller-${count.index + 1}"
    Role = "controller"
    AZ = element(
      aws_subnet.public[*].availability_zone,
      count.index % length(aws_subnet.controller_priv) # Assigns the availability zone based on the subnet index
    )
  }
  user_data = file("${path.module}/scripts/user_data_controller.sh")
  # user_data = filebase64("${path.module}/scripts/hello-world.sh")
#   user_data = <<-EOF
# #!/bin/bash
# exec > /var/log/user-data.log 2>&1
# set -e
# touch /tmp/it-works
# echo "Hello from controller node! July 3" > /tmp/it-works
# echo "installing apps: $(date '+%Y-%m-%d %H:%M:%S')" >> /tmp/it-works

# # Disable swap
# swapoff -a
# sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# # Install base packages
# apt-get update
# apt-get install -y ca-certificates curl gnupg lsb-release

# # Install k0s
# curl -sSLf https://get.k0s.sh | sudo sh
# k0s default-config > /etc/k0s.yaml
# k0s install controller --config /etc/k0s.yaml
# # Start k0s controller service after a short pause
# sleep 5
# systemctl enable --now k0scontroller

# # Install kubectl from official binary
# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
# install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# # Log kubernetes apps versions
# k0s version
# kubectl version --client
# EOF
}

