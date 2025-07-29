terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.5.0"
    }
  }
}

provider "aws" {
 region = "us-west-2"
 access_key = "<+pipeline.variables.aws_access_key>"
 secret_key = "<+pipeline.variables.aws_secret_key>"
}
