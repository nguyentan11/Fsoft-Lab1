terraform {
  backend "s3"{
    bucket = "fsfoft-tf-state"
    key = "lab01/s3/terraform.tfstate"
    region = "ap-southeast-1"

    dynamodb_table = "terraform-locks-state"
    encrypt = true
  }
}

provider "aws" {
    region = "ap-southeast-1" #"${var.aws_region}"
    shared_credentials_files = ["~/.aws/credentials"] #["${pathexpand(var.credentials_file_path)}"]
    profile = "default" #"${var.credentials_profile}"
}

module "vpc" {
  source = "./vpc"

  private_vpc_cidr_block = "172.16.0.0/16"
  private_subnet = "172.16.1.0/24"
  public_subnet = "172.16.2.0/24"
  availability_zone = "ap-southeast-1a"
}

module "key" {
  source = "./key"
}

/* module "newrelic" {
  source = "./newrelic"
  
  vpc_id = "${module.vpc.vpc-out}"
  private_vpc_cidr_block = "${module.vpc.private_vpc_cidr_block}"
  pri_subnet_id = "${module.vpc.private-subnet-out}"
  linux_key_name = "${module.key.linux_private_key_name}"
  linux_private_key_pem = "${module.key.linux_private_key_pem}"
  win_key_name = "${module.key.win_private_key_name}"
  win_private_key_pem = "${module.key.win_private_key_pem}"
}

module "ansible" {
  source = "./ansible"

  private_vpc_cidr_block = "${module.vpc.private_vpc_cidr_block}"
  vpc_id = "${module.vpc.vpc-out}"
  pri_subnet_id = "${module.vpc.private-subnet-out}"
  key_name = "${module.key.linux_private_key_name}"
  private_key_pem = "${module.key.linux_private_key_pem}"
  linux_private_key_pem = "${module.key.linux_private_key_pem}"
  win_private_key_pem = "${module.key.win_private_key_pem}"
  linux_private_ip = "${module.newrelic.linux_private_ip}"
  windows_private_ip = "${module.newrelic.windows_private_ip}"
  win-password = "${module.newrelic.win-password}"
  username = "${module.newrelic.username}"
  password = "${module.newrelic.password}"
} */

output "linux_private_key_pem"{
  value = module.key.linux_private_key_pem
  sensitive = true
}

output "win_private_key_pem"{
  value = module.key.win_private_key_pem
  sensitive = true
}

output "win_public_key" {
  value     = module.key.win_public_key
  sensitive = true
}

output "win-password" {
  value = module.newrelic.win-password
  sensitive = true
}