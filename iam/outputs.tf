# Outputs for the user's ARN, Access Key ID, and Secret Access Key

output "iam_user_arn" {
  description = "The ARN of the created IAM user."
  value       = aws_iam_user.test-user.arn
}

output "iam_user_name" {
    description = "The name of the created IAM user."
    value = aws_iam_user.test-user.id
}

output "iam_user_tags" {
    description =  "The tags associated with the IAM user"
    value = aws_iam_user.test-user.tags_all
}

output "iam_access_key_id" {
  description = "The Access Key ID for the IAM user."
  value       = aws_iam_access_key.test-key.id
}

output "iam_secret_access_key" {
  description = "The Secret Access Key for the IAM user. (WARNING: This is sensitive and should be handled with care!)"
  value       = aws_iam_access_key.admin_user_key.secret
  sensitive   = true # Marks the output as sensitive, so Terraform will redact it in console output.
}