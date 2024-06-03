data "aws_vpc" "main" {
  id = var.vpc_id
}

#subnets
#--------------------------------------------------------------

resource "aws_subnet" "public_subnet" {
  vpc_id                  = data.aws_vpc.main.id
  availability_zone       = var.availability_zone_1
  cidr_block              = cidrsubnet(data.aws_vpc.main.cidr_block, 8, 1)
  map_public_ip_on_launch = "true"

  tags = {
    Name = "public-subnet_1"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = data.aws_vpc.main.id
  availability_zone       = var.availability_zone_2
  cidr_block              = cidrsubnet(data.aws_vpc.main.cidr_block, 8, 2)
  map_public_ip_on_launch = "false" # por defecto

}

resource "aws_subnet" "eks-vpc-pub-sub1" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = cidrsubnet(data.aws_vpc.main.cidr_block, 8, 3)

  tags = {
    Name                                        = "eks-${var.env}-pub-${var.availability_zone_1}-sub1"
    "kubernetes.io/cluster/eks-cluster-project" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }

  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = true
}

resource "aws_subnet" "eks-vpc-pub-sub2" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = cidrsubnet(data.aws_vpc.main.cidr_block, 8, 4)

  tags = {
    Name                                        = "eks-${var.env}-pub-${var.availability_zone_2}-sub2"
    "kubernetes.io/cluster/eks-cluster-project" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }

  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true
}

resource "aws_subnet" "eks-vpc-priv-sub1" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = cidrsubnet(data.aws_vpc.main.cidr_block, 8, 5)

  tags = {
    Name                                        = "eks-${var.env}-priv-${var.availability_zone_1}-sub1"
    "kubernetes.io/cluster/eks-cluster-project" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }

  availability_zone = var.availability_zone_1
}

resource "aws_subnet" "eks-vpc-priv-sub2" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = cidrsubnet(data.aws_vpc.main.cidr_block, 8, 6)

  tags = {
    Name                                        = "eks-${var.env}-priv-${var.availability_zone_2}-sub2"
    "kubernetes.io/cluster/eks-cluster-project" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }

  availability_zone = var.availability_zone_2
}

#--------------------------------------------------------------

resource "aws_internet_gateway" "igw" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    "Project" = "vote-app"
    "Name"    = "vote-app-internet-gateway"
  }
}

resource "aws_eip" "eks-eip-nat" {
  depends_on = [aws_internet_gateway.igw]

  tags = {
    "Name" = "eks-${var.env}-eip-nat"
  }
}

resource "aws_nat_gateway" "eks-nat-gw" {
  allocation_id = aws_eip.eks-eip-nat.id
  subnet_id     = aws_subnet.eks-vpc-pub-sub1.id

  tags = {
    "Name" = "eks-${var.env}-nat-igw"
  }
}


#--------------------------------------------------------------

resource "aws_route_table" "public_route_table" {
  vpc_id = data.aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
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

resource "aws_route_table" "eks-vpc-pub-sub-rt" {
  vpc_id = data.aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "eks-${var.env}-vpc-pub-sub-rt"
  }
}

resource "aws_route_table" "eks-vpc-priv-sub1-rt" {
  vpc_id = data.aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.eks-nat-gw.id
  }

  tags = {
    Name = "eks-${var.env}-vpc-priv-sub1-rt"
  }
}

resource "aws_route_table" "eks-vpc-priv-sub2-rt" {
  vpc_id = data.aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.eks-nat-gw.id
  }

  tags = {
    Name = "eks-${var.env}-vpc-priv-sub2-rt"
  }
}

#--------------------------------------------------------------


resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_rta" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "eks-vpc-pub-sub1-rt-association" {
  subnet_id      = aws_subnet.eks-vpc-pub-sub1.id
  route_table_id = aws_route_table.eks-vpc-pub-sub-rt.id
}

resource "aws_route_table_association" "eks-vpc-pub-sub2-rt-association" {
  subnet_id      = aws_subnet.eks-vpc-pub-sub2.id
  route_table_id = aws_route_table.eks-vpc-pub-sub-rt.id
}

resource "aws_route_table_association" "eks-vpc-priv-sub1-rt-association" {
  subnet_id      = aws_subnet.eks-vpc-priv-sub1.id
  route_table_id = aws_route_table.eks-vpc-priv-sub1-rt.id
}

resource "aws_route_table_association" "eks-vpc-priv-sub2-rt-association" {
  subnet_id      = aws_subnet.eks-vpc-priv-sub2.id
  route_table_id = aws_route_table.eks-vpc-priv-sub2-rt.id
}

#--------------------------------------------------------------


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
