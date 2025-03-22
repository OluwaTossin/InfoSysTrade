resource "aws_instance" "web" {
  ami           = "ami-084568db4383264d4" 
  instance_type = "t2.micro"
  subnet_id     = var.public_subnet_id
  security_groups = [var.security_group]

  tags = {
    Name = "web-server"
  }
}
