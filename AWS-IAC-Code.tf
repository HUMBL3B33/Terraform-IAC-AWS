provider "aws" {
  region = "ap-south-1"
}
resource "aws_instance" "webserver" {
  ami           = "ami-01216e7612243e0ef"
  instance_type = "t2.micro"
}
resource "aws_instance" "loadbalancer" {
  ami           = "ami-01216e7612243e0ef"
  instance_type = "t2.micro"
}
resource "aws_instance" "database" {
  ami           = "ami-01216e7612243e0ef"
  instance_type = "t2.micro"
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

resource "aws_route_table" "IAC-route" {
  vpc_id = aws_vpc.IAC-VPC.id

  route {
    cidr_block = "10.0.0.0/24"
    gateway_id = aws_internet_gateway.IAC-IGW.id
  }

  tags = {
    Name = "IAC-route"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.IAC-subnet.id
  route_table_id = aws_route_table.IAC-route.id
}
resource "aws_route_table_association" "b" {
  gateway_id     = aws_internet_gateway.IAC-IGW.id
  route_table_id = aws_route_table.IAC-route.id
}