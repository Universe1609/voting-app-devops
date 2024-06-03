provider "aws" {
  region = "us-east-2"
  default_tags {
    tags = {
      "project" = "todo-list"
    }
  }
}

module "vpc" {
  source = "./modules/VPC"
}

module "instances" {
  source                 = "./modules/EC2"
  environment            = "dev"
  public_subnet_id       = module.vpc.public_subnet_id
  private_subnet_id      = module.vpc.private_subnet_id
  jenkins_security_group = module.vpc.jenkins_security_group
  availability_zone      = "us-east-2a"
  instance_profile       = module.iam.instance_profile
}

module "iam" {
  source = "./modules/IAM"
}

//module "backend" {
//  source = "./modules/backend"
//}

////module "eks" {
//  source  = "terraform-aws-modules/eks/aws"
//  version = "~> 20.0"
//
//  cluster_name    = var.cluster_name
//  cluster_version = var.cluster_version
//
//  cluster_endpoint_public_access  = true
//  cluster_endpoint_private_access = true
//
//  cluster_addons = {
//    coredns = {
//      most_recent = true
//    }
//    kube-proxy = {
//      most_recent = true
//    }
//    vpc-cni = {
//      most_recent = true
//    }
//  }
//
//  vpc_id = module.vpc.vpc_id
//  subnet_ids = [module.vpc.eks-vpc-pub-subnet-1,
//    module.vpc.eks-vpc-pub-subnet-2,
//    module.vpc.eks-vpc-priv-subnet-1,
//  module.vpc.eks-vpc-priv-subnet-2]
//  # control_plane_subnet_ids = ["subnet-xyzde987", "subnet-slkjf456", "subnet-qeiru789"]
//
//  # EKS Managed Node Group(s)
//  eks_managed_node_group_defaults = {
//    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
//    disk_size      = 50
//  }
//
//  eks_managed_node_groups = {
//    general = {
//      min_size     = 1
//      max_size     = 3
//      desired_size = 2
//
//      instance_types = ["t3.large"]
//      capacity_type  = "ON_DEMAND"
//
//      labels = {
//        role = "eks_managed_node_groups_test"
//      }
//    }
//
//  }
//
//  # Cluster access entry
//  # To add the current caller identity as an administrator
//  enable_cluster_creator_admin_permissions = true
//
//  #access_entries = {
//  #  # One access entry with a policy associated
//  #  example = {
//  #    kubernetes_groups = []
//  #    principal_arn     = var.principal_arn
//
//  #    policy_associations = {
//  #      example = {
//  #        policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
//  #        access_scope = {
//  #          namespaces = ["default"]
//  #          type       = "namespace"
//  #        }
//  #      }
//  #    }
//  #  }
//  #}
//
//  tags = {
//    Environment = "prod"
//    Terraform   = "true"
//  }
//}
//
