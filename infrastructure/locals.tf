locals {
  controller_count = var.k0s_controller_count
  az_count         = length(data.aws_availability_zones.available.names)
  subnet_count     = min(local.controller_count, local.az_count)
}

# ----------------------------------------------------
# GENERATE controller_connect_k0s.sh
# ----------------------------------------------------
resource "local_file" "controller_connect_k0s" {
  filename        = "${path.module}/scripts/controller_connect_k0s.sh"
  file_permission = "0755"

  content = <<-EOT
    #!/bin/bash

    echo "Connecting to controller nodes from bastion (using agent forwarding)..."

    %{ for instance in aws_instance.controller ~}
    echo ""
    echo "Connecting to controller at ${instance.private_ip}..."
    ssh -A -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ubuntu@${instance.private_ip}
    %{ endfor ~}
  EOT
}

# ----------------------------------------------------
# GENERATE bastians_connect_k0s.sh
# ----------------------------------------------------
resource "local_file" "bastians_connect_k0s" {
  filename        = "${path.module}/scripts/bastian_connect_k0s.sh"
  file_permission = "0755"

  content = <<-EOT
    echo "Removing all identities from ssh-agent..."
    ssh-add -D

    echo "Adding new identities to ssh-agent..."
    PEM_FILE="../pems/${var.key_name}-${random_string.key_suffix.result}.pem"

    echo "Checking if ssh-agent is running..."
    if ! ssh-add -L &>/dev/null; then
      echo "Starting ssh-agent..."
      eval "$(ssh-agent -s)"
    fi

    echo "Setting permissions on PEM file: $PEM_FILE"
    chmod 400 $PEM_FILE
  
    echo "Adding PEM file to SSH agent..."
    ssh-add $PEM_FILE

    echo ""
    echo "SSH into bastion:"
    ssh -A -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ubuntu@${aws_instance.bastion[0].public_dns}
  EOT
}
