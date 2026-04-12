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

  ignore_tags {
    keys = ["cloud-nuke-first-seen"]
  }
}

# RESOURCES

module "vpc" {
  source = "../../modules/basic-aws-vpc"

  name       = "main"
  cidr_block = "10.0.0.0/16"

  # public subnet
  public_subnet = {
    name              = "public-subnet"
    cidr_block        = "10.0.1.0/24"
    availability_zone = "mx-central-1a"
  }

  # private subnet
  private_subnet = {
    name              = "private-subnet"
    cidr_block        = "10.0.101.0/24"
    availability_zone = "mx-central-1a"
  }
}