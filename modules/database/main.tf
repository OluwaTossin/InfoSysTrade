resource "aws_db_instance" "main" {
  allocated_storage    = 20
  engine              = "mysql"
  instance_class      = "db.t3.micro"
  username           = "admin"
  password           = "mypassword"
  db_subnet_group_name = var.db_subnet_group

  tags = {
    Name = "rds-db"
  }
}
