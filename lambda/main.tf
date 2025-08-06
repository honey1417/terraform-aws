# IAM role for LAMBDA --> allows your Lambda function to run in AWS

resource "aws_iam_role" "lambda_test" {
    name = "lambda_exec_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Action = "sts:AssumeRole",
                Effect = "Allow",
                Principal = {
                    Service = "lambda.amazonaws.com"
                }

            }
        ]

    })
}

# Attach basic execution role -->  lets the Lambda write logs to CloudWatch

resource "aws_iam_role_policy_attachment" "lambda_logs" {
    role = aws_iam_role.lambda_test.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

}

# package lambda code --> Terraform zips your Python code so AWS can deploy it.

data "archive_file" "lambda_zip" {
    type = "zip"
    source_file = "${path.module}/lambda_function.py"
    output_path = "${path.module}/lambda_function.zip"

}

#lambda function --> deploys your zipped code to Lambda.
# handler = "lambda_function.lambda_handler" means:
#File = lambda_function.py
#Function = lambda_handler

resource "aws_lambda_function" "hello_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "hello_lambda"
  role             = aws_iam_role.lambda_test.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  runtime = "python3.9"
}

# S3 Bucket --> creates S3 bucket 

resource "aws_s3_bucket" "trigger_bucket" {
  bucket = "my-terraform-trigger-bucket-123456"  # must be globally unique
}

#allow s3 to invoke lambda -->You must explicitly allow S3 to invoke the Lambda using this resource.
#AWS security is strict

resource "aws_lambda_permission" "allow_s3" {
    statement_id = "AllowS3Invoke"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.hello_lambda.function_name
    principal = "s3.amazonaws.com"
    source_arn = aws_s3_bucket.trigger_bucket.arn
}

#S3 Event notification to trigger lambda
# sets up the S3 bucket to notify (trigger) the Lambda whenever an object is created (file is uploaded).
#depends_on ensures the permission is in place first before creating the trigger.

resource "aws_s3_bucket_notification" "lambda_trigger" {
    bucket = aws_s3_bucket.trigger_bucket.id

    lambda_function {
        lambda_function_arn = aws_lambda_function.hello_lambda.arn
        events = ["s3:ObjectCreated:*"]

    }

    depends_on = [aws_lambda_permission.allow_s3, aws_s3_bucket.trigger_bucket]
}