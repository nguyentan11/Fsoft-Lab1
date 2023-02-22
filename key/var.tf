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

variable "key_name_linux" {
  type = string
  default = "Tan-TF-Linux-key"
}

variable "key_name_win" {
  type = string
  default = "Tan-TF-Windows-key"
}