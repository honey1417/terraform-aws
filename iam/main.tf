# 1. Create an IAM User
resource "aws_iam_user" "test-user" {
  name = "harness-test-user"
  path = "/"

  tags = {
    access = "admin and ec2"
    Environment = "dev"
  }
}

# 2. Create Access Key and Secret Key for the IAM User
resource "aws_iam_access_key" "test-key" {
  user    = aws_iam_user.test-user.name
}

# 3. Attach AWS Managed Policies to the IAM User

# Policy 1: AdministratorAccess (Full access to all AWS services and resources)
resource "aws_iam_user_policy_attachment" "admin-acess" {
  user       = aws_iam_user.test-user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Policy 2: AmazonEC2FullAccess (Full access to EC2 resources)
resource "aws_iam_user_policy_attachment" "ec2-acess" {
  user       = aws_iam_user.test-user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}