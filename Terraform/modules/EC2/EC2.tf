resource "aws_instance" "jenkins_instance" {
  ami                  = var.ami
  availability_zone    = var.availability_zone
  instance_type        = var.instance_type
  security_groups      = [var.jenkins_security_group]
  subnet_id            = var.public_subnet_id
  key_name             = "devsecops_project"
  iam_instance_profile = var.instance_profile

  #ansible instead of bash script
  #user_data = templatefile("./user-data.sh")

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }
  tags = {
    "name" = "${var.environment}-jenkins"
  }
}

resource "aws_ebs_volume" "jenkins_ebs" {
  availability_zone = var.availability_zone
  size              = 30
  type              = "gp2"
}

resource "aws_volume_attachment" "ebs_jenkins" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.jenkins_ebs.id
  instance_id = aws_instance.jenkins_instance.id
}


//monitoring instances

#resource "aws_instance" "monitoring_instance" {
#  ami               = var.ami_amazon
#  availability_zone = var.availability_zone
#  instance_type     = var.instance_type
#  security_groups   = [var.monitoring_security_group]
#  subnet_id         = var.private_subnet_id
#  key_name          = "devsecops_project"
#
#  //user_data = templatefile("./user-data.sh") ansible use
#
#  root_block_device {
#    volume_size = 50
#    volume_type = "gp2"
#  }
#}
#  
