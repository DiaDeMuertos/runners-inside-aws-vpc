# RESOURCES

resource "aws_instance" "ec2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.sg.id]
  subnet_id                   = var.subnet_id != null ? var.subnet_id : local.subnet_1a
  associate_public_ip_address = var.associate_public_ip_address

  user_data = var.user_data

  user_data_replace_on_change = true

  metadata_options {
    http_tokens = "required" # 👈 Enforce IMDSv2
  }

  root_block_device {
    encrypted = true # 👈 Enable encryption at rest    
  }

  tags = {
    Name = var.name
  }
}

# tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group" "sg" {
  name        = "${var.name}-sg"
  description = "security grup for ec2 instance"
  vpc_id      = var.vpc_id != null ? var.vpc_id : data.aws_vpc.default.id

  tags = {
    Name = "${var.name}-sg"
  }
}

# tfsec:ignore:aws-ec2-no-public-egress-sgr
# tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "allow_it_rules" {
  for_each = var.security_group_rules

  type              = each.value.type
  from_port         = each.value.port
  to_port           = each.value.port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  description       = each.value.description
  security_group_id = aws_security_group.sg.id
}
