resource "aws_db_instance" "rds" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.0.31"
  instance_class       = "db.t2.micro"
  multi_az             = true
  identifier           = "shj-rds"
  username             = "shjinfra"
  password             = "shjinfra7"
  parameter_group_name = "rds.mysql8.0"
  db_subnet_group_name = "${aws_db_subnet_group.db_subnet_group.id}"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.sg_private_rds.id]
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "db_subnet_group"
  subnet_ids = [aws_subnet.private_subnet_rds_active.id, aws_subnet.private_subnet_rds_standby.id]

  tags = {
    Name = "db_subnet_group"
  }
}
