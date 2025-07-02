# The unique name of the generated key pair
output "key_pair_name" {
  description = "The name of the generated key pair"
  value       = aws_key_pair.k0s_key_pair.key_name
}

# Path to the generated PEM file
output "pem_file_path" {
  description = "Path to the generated PEM private key file"
  value       = local_file.private_key.filename
}

# Ingress ALB DNS
output "ingress_alb_dns" {
  description = "Public DNS of the Ingress ALB"
  value       = aws_lb.ingress_alb.dns_name
}

# Kubernetes API NLB DNS
output "k0s_api_nlb_dns" {
  description = "DNS name of the Kubernetes API NLB"
  value       = aws_lb.k0s_api_nlb.dns_name
}

# NAT Gateway public IP
output "nat_gateway_eip" {
  description = "Elastic IP of the NAT Gateway"
  value       = aws_eip.nat_eip.public_ip
}

# Public subnet IDs
output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

# Public subnet CIDRs
output "public_subnet_cidrs" {
  description = "CIDR blocks of public subnets"
  value       = aws_subnet.public[*].cidr_block
}

# Worker ASG name
output "workers_asg_name" {
  description = "The unique name of the worker Auto Scaling Group"
  value       = aws_autoscaling_group.workers_asg.name
}

# Bastion public IPs
output "bastion_public_ips" {
  description = "Public IP addresses of all bastion servers"
  value       = [for b in aws_instance.bastion : b.public_ip]
}

# Bastion public DNS
output "bastion_public_dns" {
  description = "Public DNS names of all bastion servers"
  value       = [for b in aws_instance.bastion : b.public_dns]
}

# Controller private IPs (for SSH access from bastion)
output "controller_private_ips" {
  description = "Private IPs of controller nodes for SSH access via bastion"
  value       = [for instance in aws_instance.controller : instance.private_ip]
}

# Pre-generated SSH commands for controllers (via bastion with correct PEM file)
output "controller_ssh_commands" {
  description = "SSH commands to connect to controller nodes from bastion using correct PEM"
  value = [
    for instance in aws_instance.controller :
    "ssh -A -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ../pems/${var.key_name}-${random_string.key_suffix.result}.pem ubuntu@${instance.private_ip}"
  ]
}

# Script paths
output "bastian_connect_script" {
  description = "Path to bastian_connect_k0s.sh"
  value       = "${path.module}/scripts/bastian_connect_k0s.sh"
}

output "controller_connect_script" {
  description = "Path to controller_connect_k0s.sh"
  value       = "${path.module}/scripts/controller_connect_k0s.sh"
}
