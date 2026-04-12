# VARIABLES

variable "name" {
  description = "the name of the EC2 instance"
  type        = string
}

variable "ami" {
  description = "the AMI to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "the type of EC2 instance to create"
  type        = string
}

variable "user_data" {
  description = "The User Data script to run in each Instance at boot"
  type        = string
  default     = null
}

variable "security_group_rules" {
  description = "A map of security grops to associate with the EC2 instance."
  type = map(object({
    type        = string
    name        = string
    description = string
    port        = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "subnet_id" {
  description = "the ID of the subnet to launch the EC2 instance in"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "the ID of the VPC where the security group is"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Set to true for instances in public subnets that need internet access; leave false for private subnets."
  type        = bool
  default     = true
}
