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

module "ec2" {
  source = "../../modules/basic-aws-ec2"

  name                        = "public-ec2"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  # subnet_id                   = "subnet-05b2fa0b85878119c"
  # vpc_id                      = "vpc-00ae2181a32c08f81"
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/user-data.sh", {
    server_text = "Hello, World!"
    server_port = 80
  })

  security_group_rules = {
    http = {
      type        = "ingress"
      name        = "http"
      description = "allow HTTP traffic"
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    ssh = {
      type        = "ingress"
      name        = "ssh"
      description = "allow SSH traffic"
      port        = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    all = {
      type        = "egress"
      name        = "all"
      description = "Allow all outbound traffic"
      port        = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
