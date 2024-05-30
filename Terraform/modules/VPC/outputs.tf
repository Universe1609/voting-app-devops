output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "jenkins_security_group" {
  value = aws_security_group.jenkins_security_group.id
}

output "vpc_id" {
  value = var.vpc_id
}

output "eks-vpc-pub-subnet-1" {
  value = aws_subnet.eks-vpc-pub-sub1.id
}

output "eks-vpc-pub-subnet-2" {
  value = aws_subnet.eks-vpc-pub-sub2.id
}

output "eks-vpc-priv-subnet-1" {
  value = aws_subnet.eks-vpc-priv-sub1.id
}

output "eks-vpc-priv-subnet-2" {
  value = aws_subnet.eks-vpc-priv-sub2.id
}
