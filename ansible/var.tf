/* variable "credentials_file_path" {
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
} */

variable "key_name" {
  type = string
}

variable "linux_private_key_pem" {
  type = string
}

variable "win_private_key_pem" {
  type = string
}

variable "vpc_id" {
  type = string
  description = "VPC id"
}

variable "private_vpc_cidr_block" {
  type = string
  description = "VPC CIDR"
}

variable "pri_subnet_id" {
  type = string
  description = "Private subnet id"
}

variable "private_key_pem" {
  type = string
  description = "Private key pem"
}

variable "instance_username" {
  type = string
  default = "ec2-user"
}

variable "instance_type" {
  type = string
  description = "Instance type of the EC2"
  default = "t2.micro"

 /*  validation {
    condition = contains(["t2.micro", "t3.small"], var.instance_type)
    error_message = "Value not allow."
  } */
}

variable "linux_private_ip" {
  type = string
  description = "Linux private ip"
}

variable "windows_private_ip" {
  type = string
  description = "Windows Private ip"
}

variable "linux_ami"{
  type = string
  description = "AMI for Linux instance"
  default = "ami-0f2eac25772cd4e36"
}

variable "win-password"{
  type = string
}