resource "aws_vpc" "private_vpc" {
  cidr_block = var.private_vpc_cidr_block
  #enable_dns_hostnames = true
  tags = {
    Name = "Tan_Private_VPC"
  }
}

/* resource "aws_vpc" "public_vpc" {
  cidr_block = var.public_vpc_cidr_block
  #enable_dns_hostnames = true
  tags = {
    Name = "Tan_Public_VPC"
  }
} */

resource "aws_internet_gateway" "another_gw" {
  vpc_id = aws_vpc.private_vpc.id
  tags = {
    Name = "Another Gateway"
  }
}

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet)
  
  vpc_id            = aws_vpc.private_vpc.id
  cidr_block        = var.private_subnet[count.index]
  availability_zone = var.availability_zone[count.index % length(var.availability_zone)]
  
  tags = {
    Name = "private_network_interface"
  }
}

resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet)
  
  vpc_id            = aws_vpc.private_vpc.id
  cidr_block        = var.public_subnet[count.index]
  availability_zone = var.availability_zone[count.index % length(var.availability_zone)]
  tags = {
    Name = "public_network_interface"
  }
  map_public_ip_on_launch = true
  depends_on = [aws_internet_gateway.another_gw]
}

resource "aws_default_route_table" "TF-default-route" {
  default_route_table_id = aws_vpc.private_vpc.default_route_table_id
  route{
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.another_gw.id
  }
}

/* output "vpc-out" {
  value = aws_vpc.private_vpc.id
}

output "subnet-out" {
  value = aws_subnet.private_subnet.id
} */