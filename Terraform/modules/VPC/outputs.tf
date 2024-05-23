output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "jenkins_security_group" {
  value = aws_security_group.jenkins_security_group.id
}
