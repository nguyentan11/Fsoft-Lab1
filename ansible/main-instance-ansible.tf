/*  provider "aws" {
    region = var.aws_region
    shared_credentials_files = ["${pathexpand(var.credentials_file_path)}"]
    profile = var.credentials_profile
} */

resource "aws_security_group" "secu-group-ansible" {
  name = "Ansible Linux"
  description = "Ansible Linux secu group"
  vpc_id = var.vpc_id #"vpc-2ff8904b"  #aws_vpc.private_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]#[aws_subnet.private_subnet.cidr_block]
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
    ami = var.linux_ami #"ami-0f2eac25772cd4e36" # Amazon Linux 2
    instance_type = var.instance_type #"t2.micro"
    subnet_id = var.pri_subnet_id #"subnet-1862547c" #aws_subnet.private_subnet.id 
    security_groups = [aws_security_group.secu-group-ansible.id]
    key_name = var.key_name #"Tan-TF-key" #"tf1-key"
    associate_public_ip_address = true
   
    connection {
        host = aws_instance.li-ansible.public_ip
        type = "ssh"
        user = var.instance_username
        private_key = var.private_key_pem #"${file("D://ssh-key//tan-tf-key.pem")}"
        timeout = 10
        #tls_private_key.example.private_key_openssh #"${file("C:\\Users\\tnguyen600\\Desktop\\PGA\\tan-aws-key1.pem")}" #"${file(var.pri_key)}"
    }
    
    provisioner "remote-exec"  {
      inline = [
        "aws --profile default configure set aws_access_key_id ${var.username}",
        "aws --profile default configure set aws_secret_access_key ${var.password}",
        "echo '${var.linux_private_key_pem}' > /home/ec2-user/.ssh/li-newrelic.pem",
        "sudo chmod 400 /home/ec2-user/.ssh/*.pem",
        "sudo amazon-linux-extras install epel -y",
        "sudo amazon-linux-extras install ansible2 -y",
        "sudo yum install python2-winrm.noarch -y",
        "ansible --version",
        "ansible localhost  -m ping",
        "sudo cp /etc/ansible/hosts /etc/ansible/hosts-default",
        "sudo chown -R ec2-user:ec2-user /etc/ansible",
        "echo '[linux]' >> /etc/ansible/hosts",
        "echo '${var.linux_private_ip} ansible_ssh_private_key_file=/home/ec2-user/.ssh/li-newrelic.pem' >> /etc/ansible/hosts",
        "echo '[windows]' >> /etc/ansible/hosts",
        "echo '${var.windows_private_ip}' >> /etc/ansible/hosts",
        "echo '[windows:vars]' >> /etc/ansible/hosts",
        "echo 'ansible_connection=winrm' >> /etc/ansible/hosts",
        "echo 'ansible_user=localadmin' >> /etc/ansible/hosts",
        "echo 'ansible_winrm_server_cert_validation=ignore' >> /etc/ansible/hosts",
        "echo 'ansible_password=${var.win-password}' >> /etc/ansible/hosts",
        "echo 'ansible_winrm_transport=basic' >> /etc/ansible/hosts",
        "echo 'ansible_winrm_scheme=http' >> /etc/ansible/hosts",
        "echo 'ansible_port=5985' >> /etc/ansible/hosts",
        "aws s3 cp s3://fsoft-lab1/li-nrplaybook.yml /etc/ansible/",
        "aws s3 cp s3://fsoft-lab1/win-nrplaybook.yml /etc/ansible/",
        "ansible-galaxy collection install ansible.windows",
        "ansible-galaxy collection install community.windows",
        "ansible-playbook -i /etc/ansible/hosts /etc/ansible/li-nrplaybook.yml",
      ]
    }

/*     provisioner "local-exec" {
      command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ec2-user --key-file D://ssh-key//Tan-TF-Linux-key.pem -T 300 -i '${self.public_ip},', li-nrplaybook.yaml"
    } */

    tags = {
      Name = "linux-ansible"
    }
}
