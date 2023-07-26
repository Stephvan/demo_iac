# terraform.tfvars

# Networking Configuration
networking = {
  cidr_block      = "141.0.0.0/16"
  region          = "us-west-2"
  vpc_name        = "lifebit-dev-default-vpc-01"
  azs             = ["us-west-2a", "us-west-2b"]
  public_subnets  = ["141.0.1.0/24", "141.0.2.0/24"]
  private_subnets = ["141.0.3.0/24", "141.0.4.0/24"]
  nat_gateways    = true
}

ssh-key_name = "lifebit-dev-node-sshkey-01"

# Security Groups Configuration
security_groups = [
  {
    name        = "lifebit-dev-default-secgrp-01"
    description = "Inbound & Outbound traffic for custom-security-group"
    ingress = [
      {
        description      = "Allow HTTPS"
        protocol         = "tcp"
        from_port        = 443
        to_port          = 443
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
      },
      {
        description      = "Allow HTTP"
        protocol         = "tcp"
        from_port        = 80
        to_port          = 80
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
      },
      {
        description      = "Allow SSH access on specific IPs"
        protocol         = "tcp"
        from_port        = 22
        to_port          = 22
        cidr_blocks      = ["74.19.2.23"]
        ipv6_cidr_blocks = []
      },
    ]
    egress = [
      {
        description      = "Allow all outbound traffic"
        protocol         = "-1"
        from_port        = 0
        to_port          = 0
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
      }
    ]
  }
]

# EKS Cluster Configuration
cluster_config = {
  name    = "lifebit-dev-default-eks-01"
  version = "1.27"
}

# Node Groups Configuration
node_groups = [
  {
    name           = "t2-micro-standard"
    instance_types = ["t2.micro"]
    ami_type       = "AL2_x86_64"
    capacity_type  = "ON_DEMAND"
    disk_size      = 100
    scaling_config = {
      desired_size = 19
      max_size     = 20
      min_size     = 1
    }
    update_config = {
      max_unavailable = 1
    }
  },
  {
    name           = "t2-micro-spot"
    instance_types = ["t2.micro"]
    ami_type       = "AL2_x86_64"
    capacity_type  = "SPOT"
    disk_size      = 100
    scaling_config = {
      desired_size = 19
      max_size     = 20
      min_size     = 1
    }
    update_config = {
      max_unavailable = 1
    }
  },
]

# Addons Configuration
addons = [
  {
    name    = "kube-proxy"
    version = "v1.27.1-eksbuild.1"
  },
  {
    name    = "vpc-cni"
    version = "v1.12.6-eksbuild.2"
  },
  {
    name    = "coredns"
    version = "v1.10.1-eksbuild.2"
  },
  {
    name    = "aws-ebs-csi-driver"
    version = "v1.12.6-eksbuild.2"
  }
]

ecr_repo_name       = "lifebit-dev-default-ecrrepo-01"

public_subnet_name  = "lifebit-dev-default-publicsubnet-01"
private_subnet_name  = "lifebit-dev-default-privatesubnet-01"
internet_gateway_name  = "lifebit-dev-default-igw-01"
eip_name                  = "lifebit-dev-default-eip-01"
/* public_route_table_name  = "lifebit-dev-default-pubrttable-01"
private_route_table_name  ="lifebit-dev-default-prirttable" */