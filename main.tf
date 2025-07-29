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
              sudo yum update -y
              # Install Apache HTTP server
              sudo yum install -y httpd
              # Start the Apache service
              sudo systemctl start httpd
              # Enable Apache to start on every system boot
              sudo systemctl enable httpd
              # Create a simple index.html file for demonstration
              echo "<h1>Hello from Terraform and Apache!</h1>" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name = "test-instance"
  }
}
