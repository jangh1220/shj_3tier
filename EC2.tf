data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

#public_bastion
resource "aws_instance" "public_bastion" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t2.micro"
  availability_zone = "ap-northeast-2a"
  associate_public_ip_address = true
  subnet_id = aws_subnet.public_subnet_1.id
  key_name = "shj"
  vpc_security_group_ids = [
      aws_security_group.sg_public_bastion.id
  ]
  tags = {
    Name = "public_bastion"
  }
}

#private_web
resource "aws_instance" "private_web" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t2.micro"
  availability_zone = "ap-northeast-2a"
  associate_public_ip_address = true
  subnet_id = aws_subnet.private_subnet_web1.id
  key_name = "shj"
  vpc_security_group_ids = [
      aws_security_group.sg_private_web.id
  ]
  tags = {
    Name = "private_web"
  }
}


#private_was
resource "aws_instance" "private_was" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t2.micro"
  availability_zone = "ap-northeast-2a"
  associate_public_ip_address = true
  subnet_id = aws_subnet.private_subnet_was1.id
  key_name = "shj"
  vpc_security_group_ids = [
      aws_security_group.sg_private_was.id
  ]
  tags = {
    Name = "private_was"
  }
}
