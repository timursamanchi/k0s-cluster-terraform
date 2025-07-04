
# production grade  kubernetes k0s cluster deployment

[![Terraform Version](https://img.shields.io/badge/Terraform-1.0%2B-blue?logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazon-aws)](https://aws.amazon.com/)
[![License](https://img.shields.io/badge/license-MIT-green)](./LICENSE)

This project provides an **infrastructure-as-code (IaC)** solution to deploy a **multi-node Kubernetes cluster using k0s** on **AWS Cloud** with **Terraform**.

---

## 📌 Overview

- **Technology:** Terraform + AWS EC2 + k0s (lightweight Kubernetes)
- **Purpose:** Automate provisioning of a production-grade Kubernetes cluster with controller and worker nodes on AWS.
- **Features:**
  - Configurable number of controller and worker nodes
  - Load balancer and networking setup
  - NAT gateway for internet access
  - Key pair generation for SSH access
  - Storage provisioning
  - Outputs of key infrastructure details for easy connection

---

## 🖥️ Architecture Diagram

![Architecture Diagram](./A_README.md_file_of_a_project_titled_“k0s_Cluster_.png)

---

## 🗂️ Project Structure

```
.
├── infrastructure/
│   ├── key-pair.tf              # Creates SSH key pair for EC2 access
│   ├── k0s-workers.tf           # Defines worker node EC2 instances
│   ├── lb-apps.tf               # Application load balancer setup
│   ├── lb-network.tf            # Network load balancer setup
│   ├── locals.tf                # Local variables definitions
│   ├── nat-gateway.tf           # NAT gateway resources
│   ├── outputs.tf               # Outputs key information (IP addresses, etc)
│   ├── providers.tf             # AWS provider configuration
│   ├── routes.tf                # Route tables and routing rules
│   ├── storage.tf               # EBS volume and storage setup
├── LICENSE                      # Project license
├── README.md                    # Project documentation (this file)
├── .gitignore                   # Git ignore rules
```

---

## 🚀 Deployment Instructions

### 1️⃣ Prerequisites

- [Terraform](https://www.terraform.io/) installed (>= v1.0)
- AWS credentials configured (`~/.aws/credentials` or environment variables)
- SSH client to connect to EC2 nodes

### 2️⃣ Initialize Terraform

```bash
terraform init
```

### 3️⃣ Plan infrastructure

```bash
terraform plan
```

### 4️⃣ Apply changes

```bash
terraform apply
```

⚠️ **Note:** This will create AWS resources and may incur charges.

### 5️⃣ Retrieve node information

Example command to list controller private IPs:

```bash
aws ec2 describe-instances   --filters "Name=tag:Name,Values=*controller*"   --query "Reservations[*].Instances[*].[Tags[?Key=='Name']|[0].Value, PrivateIpAddress]"   --output table
```

---

## ⚙️ Example Post-Deployment Script

```bash
#!/bin/bash
touch /tmp/it-worked
echo "SCRIPTED: Hello, World! From Kubernetes - Timur" > /tmp/helloworld.txt
echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')" >> /tmp/helloworld.txt
```

---

## 📄 License

This project is licensed under the terms of the included `LICENSE` file.

---
