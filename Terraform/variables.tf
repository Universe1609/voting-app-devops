variable "cluster_name" {
  default = "eks-cluster-vote-project"
}

variable "cluster_version" {
  default = "1.29"
}

variable "principal_arn" {
  default = "arn:aws:iam::844646036290:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS"
}
