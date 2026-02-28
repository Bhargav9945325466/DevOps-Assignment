provider "aws" {
  region = "ap-south-1"
}

# VPC
resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "dev-vpc" }
}

# Subnet
resource "aws_subnet" "dev_public_subnet" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = { Name = "dev-public-subnet" }
}

# Internet Gateway
resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = { Name = "dev-igw" }
}

# Route Table
resource "aws_route_table" "dev_route_table" {
  vpc_id = aws_vpc.dev_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_igw.id
  }
  tags = { Name = "dev-route-table" }
}

resource "aws_route_table_association" "dev_route_assoc" {
  subnet_id      = aws_subnet.dev_public_subnet.id
  route_table_id = aws_route_table.dev_route_table.id
}

# Security Group
resource "aws_security_group" "dev_sg" {
  name   = "dev-security-group"
  vpc_id = aws_vpc.dev_vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow App"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "dev-sg" }
}

# EC2
resource "aws_instance" "dev_ec2" {
  ami                         = "ami-0f5ee92e2d63afc18"
  instance_type               = "t3.micro"
  key_name = "backend-key"
  subnet_id                   = aws_subnet.dev_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.dev_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
#!/bin/bash
yum update -y
yum install -y docker
systemctl start docker
usermod -a -G docker ec2-user
EOF

  tags = { Name = "dev-backend-instance" }
}