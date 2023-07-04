terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.1.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-2"
}

# Create a VPC
resource "aws_vpc" "shj_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "shj_vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.shj_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "public_subnet_1"
  }
}


resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.shj_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_2"
  }
}

resource "aws_subnet" "private_subnet_web1" {
  vpc_id     = aws_vpc.shj_vpc.id
  cidr_block = "10.0.100.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "private_subnet_web1"
  }
}

resource "aws_subnet" "private_subnet_web2" {
  vpc_id     = aws_vpc.shj_vpc.id
  cidr_block = "10.0.101.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "private_subnet_web2"
  }
}

resource "aws_subnet" "private_subnet_was1" {
  vpc_id     = aws_vpc.shj_vpc.id
  cidr_block = "10.0.200.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "private_subnet_was1"
  }
}

resource "aws_subnet" "private_subnet_was2" {
  vpc_id     = aws_vpc.shj_vpc.id
  cidr_block = "10.0.201.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "private_subnet_was2"
  }
}

resource "aws_subnet" "private_subnet_rds_active" {
  vpc_id     = aws_vpc.shj_vpc.id
  cidr_block = "10.0.300.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "private_subnet_rds_active"
  }
}

resource "aws_subnet" "private_subnet_rds_standby" {
  vpc_id     = aws_vpc.shj_vpc.id
  cidr_block = "10.0.301.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "private_subnet_rds_standby"
  }
}



#public_subnet1에 nat_gateway 배치
resource "aws_eip" "elastic_ip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "public_nat" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.shj_vpc.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.shj_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.shj_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public_nat.id
  }

  tags = {
    Name = "private_route_table"
  }
}

resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_3_association" {
  subnet_id      = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_4_association" {
  subnet_id      = aws_subnet.private_subnet_4.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_5_association" {
  subnet_id      = aws_subnet.private_subnet_5.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_6_association" {
  subnet_id      = aws_subnet.private_subnet_6.id
  route_table_id = aws_route_table.private_route_table.id
}