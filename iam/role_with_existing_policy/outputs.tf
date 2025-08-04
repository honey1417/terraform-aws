output "role_arn" {
    value = aws_iam_role.ec2readonly_role.arn
}

output "role_create_date" {
    value = aws_iam_role.ec2readonly_role.create_date 
}

output "role_id" {
    value =  aws_iam_role.ec2readonly_role.id
}

output "role_name" {
    value =  aws_iam_role.ec2readonly_role.name
}

output "role_tags" {
    value =  aws_iam_role.ec2readonly_role.tags_all
}

output "instance_public_ip" {
  value = aws_instance.test.public_ip
}