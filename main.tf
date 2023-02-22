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

module "newrelic" {
  source = "./newrelic"
  
  vpc_id = "${module.vpc.vpc-out}"
  pri_subnet_id = "${module.vpc.private-subnet-out}"
  key_name = "${module.key.private_key_name}"
  private_key_pem = "${module.key.private_key_pem}"
}

module "ansible" {
  source = "./ansible"

  private_vpc_cidr_block = "${module.vpc.private_vpc_cidr_block}"
  vpc_id = "${module.vpc.vpc-out}"
  pri_subnet_id = "${module.vpc.private-subnet-out}"
  key_name = "${module.key.private_key_name}"
  private_key_pem = "${module.key.private_key_pem}"
  linux_private_ip = "${module.newrelic.linux_private_ip}"
  windows_private_ip = "${module.newrelic.windows_private_ip}"
}

