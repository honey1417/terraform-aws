output "volume_id" {
    value = aws_ebs_volume.vol_test.id
}

output "instance_id" {
    value = aws_instance.test_instance.id
}

output "device_id" {
    value = aws_volume_attachment.vol_attach.device_name
}

