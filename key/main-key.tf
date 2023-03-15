/*  provider "aws" {
    region = "${var.aws_region}"
    shared_credentials_files = ["${pathexpand(var.credentials_file_path)}"]
    profile = "${var.credentials_profile}"
} */

resource "tls_private_key" "tan-private-linux" {
  algorithm = "RSA"
  rsa_bits = 2048
}

resource "aws_key_pair" "linux_key" {
  depends_on = [
    tls_private_key.tan-private-linux
  ]
  key_name = "${var.key_name_linux}"
  public_key = "${tls_private_key.tan-private-linux.public_key_openssh}"
  tags = {
    Name = "Tan-TF-Linux-ssh-key"
  }
}

resource "local_file" "Linux_ssh_key" {
  filename = "${aws_key_pair.linux_key.key_name}"
  content  = tls_private_key.tan-private-linux.private_key_pem
}

resource "tls_private_key" "tan-private-win" {
  algorithm = "RSA"
  rsa_bits = 2048
}

resource "aws_key_pair" "win_key" {
  depends_on = [
    tls_private_key.tan-private-win
  ]
  key_name = "${var.key_name_win}"
  public_key = "${tls_private_key.tan-private-win.public_key_openssh}"
  tags = {
    Name = "Tan-TF-Windows-ssh-key"
  }
}

resource "local_file" "Windows_ssh_key" {
  filename = "${aws_key_pair.win_key.key_name}"
  content  = tls_private_key.tan-private-win.private_key_pem
}

resource "aws_ssm_parameter" "linux_prkey_secret"{
  name = "/${var.key_name_linux}"
  description = "Linux host private key"
  type = "String"
  value = tls_private_key.tan-private-linux.private_key_pem
  overwrite = true
}

resource "aws_ssm_parameter" "win_prkey_secret"{
  name = "/${var.key_name_win}"
  description = "Windows host private key"
  type = "String"
  value = tls_private_key.tan-private-win.private_key_pem
  overwrite = true
}

output "linux_private_key_name" {
  value     = var.key_name_linux
}

output "linux_private_key_pem" {
  value     = tls_private_key.tan-private-linux.private_key_pem
  sensitive = true
}

output "linux_public_key" {
  value     = tls_private_key.tan-private-linux.public_key_openssh
  sensitive = true
}

output "win_private_key_name" {
  value     = var.key_name_win
}

output "win_private_key_pem" {
  value     = tls_private_key.tan-private-win.private_key_pem
  sensitive = true
}

output "win_public_key" {
  value     = tls_private_key.tan-private-win.public_key_openssh
  sensitive = true
}