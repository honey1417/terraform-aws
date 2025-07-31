resource "aws_s3_bucket" "s3-test" {
  bucket = "hashicorp-aws-us-west-2-test-bucket"

  tags = {
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "s3-versioning" {
  bucket = aws_s3_bucket.s3-test.id
  versioning_configuration {
    status = "Enabled"
  }
}