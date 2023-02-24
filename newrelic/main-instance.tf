/*  provider "aws" {
    region = "${var.aws_region}"
    shared_credentials_files = ["${pathexpand(var.credentials_file_path)}"]
    profile = "${var.credentials_profile}"
} */

resource "aws_security_group" "secu-group-test2" {
  name = "New Relic"
  description = "New Relic secu group"
  vpc_id = var.vpc_id #"vpc-2ff8904b"  #aws_vpc.private_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]#[aws_subnet.private_subnet.cidr_block]
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
    cidr_blocks = ["${var.private_vpc_cidr_block}"]
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

resource "aws_instance" "li" {
    #count = 3 
    ami = var.linux_ami #"ami-0f2eac25772cd4e36" # Amazon Linux 2
    instance_type = var.instance_type #"t2.micro"
    subnet_id = var.pri_subnet_id #"subnet-1862547c" #aws_subnet.private_subnet.id 
    security_groups = [aws_security_group.secu-group-test2.id]
    source_dest_check = false
    key_name = var.linux_key_name #"Tan-TF-key" #"tf1-key"
    associate_public_ip_address = true
   
    connection {
        host = aws_instance.li.public_ip
        type = "ssh"
        user = var.instance_username
        private_key = var.linux_private_key_pem #"${file("D://terraform//ssh-key//tan-tf-key.pem")}"
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
}

resource "aws_instance" "win" {
  ami = var.windows_ami #"ami-0bc64185df5784cc3"
  instance_type = var.instance_type
  subnet_id = var.pri_subnet_id
  vpc_security_group_ids = [aws_security_group.secu-group-test2.id]
  source_dest_check = false
  key_name = var.win_key_name
  user_data = data.template_file.windows-userdata.rendered 
  associate_public_ip_address = true
  get_password_data = true
  
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
}

output "linux_private_ip" {
  value       = aws_instance.li.private_ip
  description = "Linux private ip"
}

output "windows_private_ip" {
  value       = aws_instance.win.private_ip
  description = "Windows private ip"
}

/* output "password_window_decrypted" {
  value = rsadecrypt(aws_instance.win.password_data, file("${var.win_public_key}")) 
  sensitive = true
} */