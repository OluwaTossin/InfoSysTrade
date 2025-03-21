resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # Use a valid AWS AMI
  instance_type = "t2.micro"
  subnet_id     = var.public_subnet_id
  security_groups = [var.security_group]

  tags = {
    Name = "web-server"
  }
}
