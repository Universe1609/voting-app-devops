data "aws_vpc" "main" {
  id = var.vpc_id
}

#subnets
resource "aws_subnet" "public_subnet" {
  vpc_id                  = data.aws_vpc.main.id
  availability_zone       = var.availability_zone_1
  cidr_block              = cidrsubnet(data.aws_vpc.main.cidr_block, 4, 1)
  map_public_ip_on_launch = "true"

}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = data.aws_vpc.main.id
  availability_zone       = var.availability_zone_2
  cidr_block              = cidrsubnet(data.aws_vpc.main.cidr_block, 4, 2)
  map_public_ip_on_launch = "false" # por defecto

}

data "aws_internet_gateway" "igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = data.aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = data.aws_vpc.main.id

  #route {
  #  cidr_block = "0.0.0.0/0"
  #  nat_gateway_id = aws_nat_gateway.example.id
  #}

  tags = {
    Name = "Private Route Table"
  }
}


resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_rta" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_security_group" "jenkins_security_group" {
  name   = "jenkins_security_group"
  vpc_id = data.aws_vpc.main.id

  ingress = [
    for port in [22, 443, 8080, 9000] : {
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "Allow inbound traffic"
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [{
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Egress"
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    security_groups  = []
    self             = false
    }
  ]
}
