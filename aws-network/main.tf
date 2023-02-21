provider "aws" {
    region = "ap-southeast-1" #"${var.aws_region}"
    shared_credentials_files = ["~/.aws/credentials"] #["${pathexpand(var.credentials_file_path)}"]
    profile = "default" #"${var.credentials_profile}"
}
module "vpc" {
  source = "./vpc"

  private_vpc_cidr_block    = "172.16.0.0/16"
  private_subnet    = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  public_subnet     = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
  availability_zone = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}

module "key" {
  source = "./key"
  
}