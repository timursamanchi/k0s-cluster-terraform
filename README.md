# multi node kubernetes-k0s-cluster-terraform
kubernetes k0s deployment of on aws cloud using terraform

#######################################
# aws ec2 describe-instances \
#   --filters "Name=tag:Name,Values=*controller*" \
#   --query "Reservations[*].Instances[*].[Tags[?Key=='Name']|[0].Value, PrivateIpAddress]" \
#   --output table

# -----------------------------
# |      DescribeInstances     |
# +-----------------+---------+
# |  my-controller-1 | 10.1.1.145 |
# |  my-controller-2 | 10.1.2.53  |
# +-----------------+---------+

#!/bin/bash
touch /tmp/it-worked
# {
#   echo "SCRIPTED: Hello, World! From Kubernetes - Timur"
#   echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
# } > /tmp/helloworld.txt

