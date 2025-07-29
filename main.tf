# Fetch existing key pair

data "aws_key_pair" "key_pair" {
  key_name = "ssh-key-pair-1"  # 👈 Replace with your key pair name
}

#to enable ssh access, security group should be created

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict to your IP!
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows HTTP from any IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#EC2 instance 

resource "aws_instance" "web" {
  ami           = "ami-05f991c49d264708f"
  instance_type = "t2.micro"
  key_name      = data.aws_key_pair.key_pair.key_name  # Reference the key
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  user_data = <<-EOF
              #!/bin/bash
              # Update all installed packages
              sudo apt update -y
              # Install Apache HTTP server (package name is apache2 on Ubuntu)
              sudo apt install -y apache2
              # Start the Apache service
              sudo systemctl start apache2 # Note: it's apache2.service or just apache2
              # Enable Apache to start on every system boot
              sudo systemctl enable apache2 # Note: it's apache2.service or just apache2
              # Create a simple index.html file for demonstration
              echo "<h1>Hello from Terraform and Apache!</h1>" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name = "test-instance"
  }
}
