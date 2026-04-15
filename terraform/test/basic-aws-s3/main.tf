terraform {
  required_version = "~>1.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.35.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      Project = "up-and-running"
    }
  }
}

# RESOURCES

module "bucket_s3" {
  source = "../../modules/basic-aws-s3"
  name   = var.name
}
