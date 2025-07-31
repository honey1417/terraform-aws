output "s3-bucket-name" {
    value = aws_s3_bucket.s3-test.id
}

output "s3-arn" {
    value = aws_s3_bucket.s3-test.arn
}

output "s3-region" {
    value = aws_s3_bucket.s3-test.bucket_region
}

output "s3-tags" {
    value = aws_s3_bucket.s3-test.tags_all
}