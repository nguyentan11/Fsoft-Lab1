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

variable "linux_key_name" {
  type = string
}

variable "linux_private_key_pem" {
  type = string
}

variable "win_key_name" {
  type = string
}

variable "win_private_key_pem" {
  type = string
}

variable "vpc_id" {
  type = string
  #default = "vpc-0f5b9240fdef55319"
}

variable "pri_subnet_id" {
  type = string
  #default = "subnet-0071a6c492c7e5730"
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

variable "private_vpc_cidr_block" {
  type = string
}

variable "linux_ami"{
  type = string
  description = "AMI for Linux instance"
  default = "ami-0f2eac25772cd4e36"
}

variable "windows_ami"{
  type = string
  description = "AMI for Linux instance"
  default = "ami-0bc64185df5784cc3"
}

# windows
variable "windows_instance_type" {
  type        = string
  description = "EC2 instance type for Windows Server"
  default     = "t2.micro"
}
variable "windows_associate_public_ip_address" {
  type        = bool
  description = "Associate a public IP address to the EC2 instance"
  default     = true
}
variable "windows_root_volume_size" {
  type        = number
  description = "Volumen size of root volumen of Windows Server"
  default     = "30"
}
variable "windows_data_volume_size" {
  type        = number
  description = "Volumen size of data volumen of Windows Server"
  default     = "10"
}
variable "windows_root_volume_type" {
  type        = string
  description = "Volumen type of root volumen of Windows Server."
  default     = "gp2"
}
variable "windows_data_volume_type" {
  type        = string
  description = "Volumen type of data volumen of Windows Server."
  default     = "gp2"
}
variable "windows_instance_name" {
  type        = string
  description = "EC2 instance name for Windows Server"
  default     = "newrelic-win01"
}