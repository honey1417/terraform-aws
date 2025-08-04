output "policy_arn" {
    value = aws_iam_policy.custom_policy.arn
}

output "policy_attachment_count" {
    value = aws_iam_policy.custom_policy.attachment_count
}

output "policy_tags" {
    value = aws_iam_policy.custom_policy.tags_all
}

output "policy_id" {
    value = aws_iam_policy.custom_policy.policy_id
}

output "instance_public_ip" {
  value = aws_instance.custom_instance.public_ip
}