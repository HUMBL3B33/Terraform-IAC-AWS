terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-south-1"
}
resource "aws_instance" "webserver" {
  ami           = "ami-01216e7612243e0ef"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.IAC-subnet.id
}
resource "aws_instance" "loadbalancer" {
  ami           = "ami-01216e7612243e0ef"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.IAC-subnet.id
}
resource "aws_instance" "database" {
  ami           = "ami-01216e7612243e0ef"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.IAC-subnet.id
}

resource "aws_vpc" "IAC-VPC" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "IAC-VPC"
  }
}

resource "aws_subnet" "IAC-subnet" {
  vpc_id     = aws_vpc.IAC-VPC.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "IAC-subnet"
  }
}

resource "aws_internet_gateway" "IAC-IGW" {
  vpc_id = aws_vpc.IAC-VPC.id

  tags = {
    Name = "IAC-IGW"
  }
}

resource "aws_route_table" "IAC-route-public" {
  vpc_id = aws_vpc.IAC-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IAC-IGW.id
  }

  tags = {
    Name = "IAC-route-public"
  }
}

resource "aws_main_route_table_association" "main" {
  vpc_id = aws_vpc.IAC-VPC.id
  route_table_id = aws_route_table.IAC-route-public.id
}