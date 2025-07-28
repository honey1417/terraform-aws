resource "aws_instance" "web" {
  ami           = "ami-05f991c49d264708f"
  instance_type = "t3.micro"

  tags = {
    Name = "Hello1"
  }
}
