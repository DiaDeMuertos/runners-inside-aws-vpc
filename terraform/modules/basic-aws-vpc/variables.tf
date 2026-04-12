# VARIABLES

variable "name" {
  description = "aws vpc name"
  type        = string
}

variable "cidr_block" {
  description = "aws vpc cidr block"
  type        = string
}

variable "public_subnet" {
  description = "aws vpc public subnet"
  type = object({
    name              = string
    cidr_block        = string
    availability_zone = string
  })
}

variable "private_subnet" {
  description = "aws vpc private subnet"
  type = object({
    name              = string
    cidr_block        = string
    availability_zone = string
  })
}
