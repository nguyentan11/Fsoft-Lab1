variable "credentials_file_path" {
  description = "The location of the creditionals file"
  type        = string
  default     = "~/.aws/credentials"
}

variable "aws_region" {
  description = "The region for this deployment"
  type        = string
  default     = "ap-southeast-1"
}

variable "credentials_profile" {
  description = "The name of profile for TF deployment"
  type = string
  default = "default"
}

variable "private_vpc_cidr_block" {
  description = "Private VPC CIDR block"
  type = string
  default = "172.16.0.0/16"
}

variable "public_vpc_cidr_block" {
  description = "Public VPC CIDR block"
  type = string
  default = "10.20.0.0/16"
}

variable "private_subnet" {
  type    = string
}

variable "public_subnet" {
  type    = string
}

variable "availability_zone" {
  type    = string
}