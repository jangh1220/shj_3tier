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

#sg_private_web
resource "aws_security_group" "sg_private_web"{
    name = "sg_private_web"
    description = "sg_private_web"
    vpc_id = aws_vpc.shj_vpc.id
    
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.sg_public_bastion.id]
  }
  
    ingress {
    from_port = 80
    to_port = 80
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
      Name = "sg_private_web"
  }
}

#sg_private_was
resource "aws_security_group" "sg_private_was"{
    name = "sg_private_was"
    description = "sg_private_was"
    vpc_id = aws_vpc.shj_vpc.id
    
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.sg_public_bastion.id]
  }
  
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.sg_alb_int.id]
  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
      Name = "sg_private_was"
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


#sg_alb_ext
resource "aws_security_group" "sg_alb_ext"{
    name = "sg_alb_ext"
    description = "sg_alb_ext" 
    vpc_id = aws_vpc.shj_vpc.id 
    ingress { 
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    } 
    ingress { 
        from_port = 80 
        to_port = 80 
        protocol = "tcp" 
        cidr_blocks = ["0.0.0.0/0"]
    } 
    ingress { 
        from_port = 443
        to_port = 443
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
        Name = "sg_alb_ext" 
    }

}


#sg_alb_int
resource "aws_security_group" "sg_alb_int" {
    name = "sg_alb_int"
    description = "sg_alb_int"
    vpc_id = aws_vpc.shj_vpc.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    } 
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.sg_alb_ext.id]
    }
    ingress {
        from_port = 0
        to_port = 65535
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
        Name = "sg_alb_int" 
    }
}
