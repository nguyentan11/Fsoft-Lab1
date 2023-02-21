 provider "aws" {
    region = "${var.aws_region}"
    shared_credentials_files = ["${pathexpand(var.credentials_file_path)}"]
    profile = "${var.credentials_profile}"
}

resource "aws_security_group" "secu-group-ansible" {
  name = "New Relic Linux"
  description = "New Relic Linux"
  vpc_id = "${var.vpc_id}" #"vpc-2ff8904b"  #aws_vpc.private_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]#[aws_subnet.private_subnet.cidr_block]
  }
  ingress {
    from_port = 5985
    to_port = 5985
    protocol = "tcp"
    cidr_blocks = ["172.16.0.0/16"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Ansible"
  }
}

resource "aws_instance" "li-ansible" {
    #count = 3 
    ami = "ami-0f2eac25772cd4e36" # Amazon Linux 2
    instance_type = "${var.instance_type}" #"t2.micro"
    subnet_id = "${var.pri_subnet_id}" #"subnet-1862547c" #aws_subnet.private_subnet.id 
    security_groups = [aws_security_group.secu-group-ansible.id]
    key_name = "${var.key_name}" #"Tan-TF-key" #"tf1-key"
    associate_public_ip_address = true
   
    connection {
        host = aws_instance.li-ansible.public_ip
        type = "ssh"
        user = var.instance_username
        private_key = "${var.private_key_pem}}"#"${file("D://ssh-key//tan-tf-key.pem")}"
        timeout = 10
        #tls_private_key.example.private_key_openssh #"${file("C:\\Users\\tnguyen600\\Desktop\\PGA\\tan-aws-key1.pem")}" #"${file(var.pri_key)}"
    }
    
    provisioner "remote-exec"  {
      inline = [
        "touch /home/ec2-user/test.txt",
        "sudo amazon-linux-extras install epel -y",
        "sudo amazon-linux-extras install ansible2 -y",
        "ansible --version",
        "ansible localhost  -m ping",
      ]
    }

    tags = {
      Name = "linux-ansible"
    }
}
