# terraform-aws

### lambda functions 

🔄 Final Flow:
1. A Lambda function is created and logs to CloudWatch.
2. An S3 bucket is created.
3. When you upload any file to the S3 bucket:
4. S3 triggers the Lambda
5. The Lambda runs and logs the event