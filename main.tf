resource "aws_instance" "web" {
  ami           = "ami-05f991c49d264708f"
  instance_type = "t2.micro"
  key_name = ""

  tags = {
    Name = "Hello1"
  }
}
