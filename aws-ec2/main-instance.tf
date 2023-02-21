 provider "aws" {
    region = "${var.aws_region}"
    shared_credentials_files = ["${pathexpand(var.credentials_file_path)}"]
    profile = "${var.credentials_profile}"
}

resource "aws_security_group" "secu-group-test" {
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
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 3389
    to_port = 3389
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
    Name = "New Relic"
  }
}

resource "aws_instance" "li-ansible" {
    #count = 3 
    ami = "ami-0f2eac25772cd4e36" # Amazon Linux 2
    instance_type = "${var.instance_type}" #"t2.micro"
    subnet_id = "${var.pri_subnet_id}" #"subnet-1862547c" #aws_subnet.private_subnet.id 
    security_groups = [aws_security_group.secu-group-test.id]
    key_name =  "Tan-TF-key" #"${var.key_name}" #"tf1-key"
    associate_public_ip_address = true
   
    connection {
        host = aws_instance.li-ansible.public_ip
        type = "ssh"
        user = var.instance_username
        private_key = "${file("D://terraform//ssh-key//tan-tf-key.pem")}"
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

/* resource "aws_instance" "li-newrelic" {
    #count = 3 
    ami = "ami-0f2eac25772cd4e36" # Amazon Linux 2
    instance_type = "${var.instance_type}" #"t2.micro"
    subnet_id = "${var.pri_subnet_id}" #"subnet-1862547c" #aws_subnet.private_subnet.id 
    security_groups = [aws_security_group.secu-group-test.id]
    key_name =  "Tan-TF-key" #"${var.key_name}" #"tf1-key"
    associate_public_ip_address = true
   
    connection {
        host = aws_instance.li-newrelic.public_ip
        type = "ssh"
        user = var.instance_username
        private_key = "${file("D://terraform//ssh-key//tan-tf-key.pem")}"
        timeout = 10
        #tls_private_key.example.private_key_openssh #"${file("C:\\Users\\tnguyen600\\Desktop\\PGA\\tan-aws-key1.pem")}" #"${file(var.pri_key)}"
    }
    
    provisioner "remote-exec"  {
      inline = [
        "touch /home/ec2-user/test.txt",
      ]
    }

    tags = {
      Name = "linux-newrelic"
    }
} */

/* resource "aws_instance" "win" {
  ami = var.windows_ami #"ami-0bc64185df5784cc3"
  instance_type = var.instance_type
  subnet_id = "${var.pri_subnet_id}"
  vpc_security_group_ids = [aws_security_group.secu-group-test.id]
  source_dest_check = false
  key_name = "Tan-TF-key"
  user_data = data.template_file.windows-userdata.rendered 
  associate_public_ip_address = true
  
  # root disk
  root_block_device {
    volume_size = var.windows_root_volume_size
    volume_type = var.windows_root_volume_type
    delete_on_termination = true
    encrypted = true
  }
  # extra disk
  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = var.windows_data_volume_size
    volume_type = var.windows_data_volume_type
    encrypted = true
    delete_on_termination = true
  }
  
  tags = {
    Name = "windows-newrelic"
  }
} */