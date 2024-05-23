output "ec2_instance_ip" {
  value       = module.instances.jenkins_instance_ip
  description = "The public IP address of the EC2 instance."
}
