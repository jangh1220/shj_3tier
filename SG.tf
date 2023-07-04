#sg_public_bastion
resource "aws_security_group" "sg_public_bastion"{
    name = "sg_public_bastion"
    description = "sg_public_bastion"
    vpc_id = aws_vpc.shj_vpc.id
    
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
      Name = "sg_public_bastion"
  }
}

#sg_private_rds
resource "aws_security_group" "sg_private_rds"{
    name = "sg_private_rds"
    description = "sg_private_rds"
    vpc_id = aws_vpc.shj_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.sg_public_bastion.id]
}

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
  tags = {
      Name = "sg_private_rds"
    }
}