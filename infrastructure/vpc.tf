#######################################
# VPC setting for k0s cluster
#######################################
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "k0s" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "k0s-vpc"
  }
}

resource "aws_internet_gateway" "k0s" {
  vpc_id = aws_vpc.k0s.id
  tags = {
    Name = "k0s-internet-gateway"
  }
}