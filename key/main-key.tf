 provider "aws" {
    region = "${var.aws_region}"
    shared_credentials_files = ["${pathexpand(var.credentials_file_path)}"]
    profile = "${var.credentials_profile}"
}

resource "tls_private_key" "tan-private" {
  algorithm = "RSA"
  rsa_bits = 2048
}

resource "aws_key_pair" "generated_key" {
  depends_on = [
    tls_private_key.tan-private
  ]
  key_name = "${var.key_name}"
  public_key = "${tls_private_key.tan-private.public_key_openssh}"
  tags = {
    Name = "Tan-TF-ssh-key"
  }
}

resource "local_file" "ssh_key" {
  filename = "D://terraform//ssh-key//${aws_key_pair.generated_key.key_name}.pem"
  content  = tls_private_key.tan-private.private_key_pem
}

output "private_key" {
  value     = tls_private_key.tan-private.private_key_pem
  sensitive = true
}

output "public_key" {
  value     = tls_private_key.tan-private.public_key_openssh
  sensitive = true
}
