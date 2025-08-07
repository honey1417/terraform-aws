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
            # Wait for EBS volume (using BOTH naming conventions)
            while [ ! -e /dev/nvme1n1 ] && [ ! -e /dev/xvdh ]; do
              sleep 10
            done
            
            # Use whichever device exists
            if [ -e /dev/nvme1n1 ]; then
              DEVICE="/dev/nvme1n1"
            else
              DEVICE="/dev/xvdh"
            fi
            
            # Format if unformatted
            if [[ $(sudo file -s $DEVICE) == *"data"* ]]; then
              sudo mkfs -t xfs $DEVICE
            fi
            
            # Mount and make persistent
            sudo mkdir /mydata
            sudo mount $DEVICE /mydata
            echo "$DEVICE /mydata xfs defaults,nofail 0 2" | sudo tee -a /etc/fstab
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