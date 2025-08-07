# 1. FIRST create the EBS volume

resource "aws_ebs_volume" "vol_test" {
    availability_zone = "us-west-2a"
    size = 10
    type = "gp3"
    tags = {
        Name = "ebs-1"
    }
}

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

# 2. THEN create the EC2 instance (depends_on volume)
resource "aws_instance" "test_instance" {
  ami           = "ami-05f991c49d264708f"
  instance_type = "t2.micro"
  availability_zone = "us-west-2a"# Must match volume AZ
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  
  # Explicit dependency on volume creation
  depends_on = [aws_ebs_volume.vol_test]

  user_data = <<-EOF
              #!/bin/bash
              # Wait for volume attachment with status messages
              echo "Starting EBS volume setup..."
              while [ ! -e /dev/nvme1n1 ]; do
                echo "Volume not attached yet, waiting 5 seconds..."
                sleep 5
              done
              echo "Volume successfully attached at /dev/nvme1n1"
              
              # List available disks
              echo "Listing available block devices:"
              lsblk
              
              # Check filesystem status
              echo "Checking filesystem status:"
              sudo file -s /dev/nvme1n1
              
              # Format if needed
              echo "Formatting volume as XFS filesystem..."
              sudo mkfs -t xfs /dev/nvme1n1
              
              # Create mount point
              echo "Creating mount point at /mydata"
              sudo mkdir /mydata
              
              # Mount volume
              echo "Mounting volume to /mydata"
              sudo mount /dev/nvme1n1 /mydata
              
              # Make mount persistent
              echo "Making mount persistent in /etc/fstab"
              echo "/dev/nvme1n1 /mydata xfs defaults,nofail 0 2" | sudo tee -a /etc/fstab
              
              # Final verification
              echo "Verifying mount:"
              df -h | grep mydata
              echo "EBS volume setup complete!"
              EOF

  tags = {
    Name = "vol_instance"
  }
 
}

resource "aws_volume_attachment" "vol_attach" {
    device_name = "/dev/sdh"
    volume_id = aws_ebs_volume.vol_test.id
    instance_id = aws_instance.test_instance.id

    # explicit dependency on instance readiness
    depends_on = [aws_instance.test_instance]
}