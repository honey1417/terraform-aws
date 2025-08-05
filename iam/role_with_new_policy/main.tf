# create custom policy 
resource "aws_iam_policy" "custom_policy" {
    name = "custom-policy"
    description = "allows only describing an Ec2"
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
          {

            Action = ["ec2:Describe*"],
            Effect = "Allow",
            Resource = "*"
          }
        ]
    })
}

#create iam role 
resource "aws_iam_role" "custom_role" {
    name = "custom_ec2_role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Action = "sts:AssumeRole",
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            }
        ]
    })
}

#attach custom policy to role
resource "aws_iam_role_policy_attachment" "custom_attach" {
    role = aws_iam_role.custom_role.name
    policy_arn = aws_iam_policy.custom_policy.arn
}

#create IAM instance profile 
resource "aws_iam_instance_profile" "custom_profile" {
    name = "custom_instance_profile"
    role = aws_iam_role.custom_role.name
}

# create ec2 instance with this new role 
resource "aws_instance" "custom_instance" {
    ami = ""
    instance_type = "t2.micro"
    iam_instance_profile = aws_iam_instance_profile.custom_profile.name

    depends_on = [aws_iam_instance_profile.custom_profile]

    tags = {
        Name = "ec2-customrole-vm"
    }
}