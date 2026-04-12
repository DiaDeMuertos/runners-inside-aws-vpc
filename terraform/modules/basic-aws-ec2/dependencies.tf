# DATA SOURCES

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "all_default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_subnet" "selected" {
  for_each = toset(data.aws_subnets.all_default.ids)
  id       = each.value
}

locals {
  subnet_1a = one([
    for s in data.aws_subnets.all_default.ids : s if endswith(data.aws_subnet.selected[s].availability_zone, "1a")
  ])
}