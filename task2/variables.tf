variable "region" {
  type = string
  description = "aws region"
  default = "eu-west-1"
}

variable "vpc_name" {
  type = string
  description = "vpc name"
  default = "test"
}

variable "vpc_cidr" {
  type = string
  description = "vpc_cidr"
  default = "10.0.0.0/16"
}

variable "vpc_azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b"]
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "key_name" {
  type = string
  description = "ec2 ssh key_name"
  default = "tribu"
}

