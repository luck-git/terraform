############vpc##########
resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = "${var.InstanceTag}-vpc"
  }
}
#public-subnet#
resource "aws_subnet" "pub-subnet1" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = var.pub_cidr[0]
  availability_zone = "us-east-2a"
  tags = {
    "Name" = "${var.InstanceTag}-pubsubnet1"
  }
}
resource "aws_subnet" "pub-subnet2" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = var.pub_cidr[1]
  availability_zone = "us-east-2b"
  tags = {
    "Name" = "${var.InstanceTag}-pubsubnet2"
  }
}
##############PRIVATE###############
resource "aws_subnet" "pvt-subnet1" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = var.pvt_cidr[0]
  availability_zone = "us-east-2a"
  tags = {
    "Name" = "${var.InstanceTag}-pvtsubnet1"
  }
}
resource "aws_subnet" "pvt-subnet2" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = var.pvt_cidr[1]
  availability_zone = "us-east-2b"
  tags = {
    "Name" = "${var.InstanceTag}-pvtsubnet2"
  }
}
#########################INTERNET GATEWAY ########################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "${var.nametag}- aws_internet_gateway"
  }
}

##########################<ROUTE-TABLE>########################
#  ----------> PUBLIC ROUTE TABLES AVAILABILITY ZONE US-EAST-2A <-------------
resource "aws_route_table" "pub_rt_1" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name   = "${var.nametag}-pub-route-table-1"
    region = "us-east-2a"
  }

}
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.pub_rt_1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
resource "aws_route_table_association" "association-1" {
  subnet_id      = aws_subnet.pub-subnet1.id
  route_table_id = aws_route_table.pub_rt_1.id
}
resource "aws_route_table_association" "association-2" {
  subnet_id      = aws_subnet.pub-subnet2.id
  route_table_id = aws_route_table.pub_rt_1.id
}
#  ----------> PUBLIC ROUTE TABLES AVAILABILITY ZONE US-EAST-2B <-------------
resource "aws_route_table" "Pub_rt_2" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name   = "${var.InstanceTag}-Pub-Route-Table-2"
    region = "us-east-2b"
  }
}
resource "aws_route" "public_internet_gateway-2" {
  route_table_id         = aws_route_table.Pub_rt_2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


#  ----------> PRIVATE ROUTE TABLES AVAILABILITY ZONE US-EAST-2A <-------------
resource "aws_route_table" "Private_rt_1" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name   = "${var.InstanceTag}-Private-Route-Table-1"
    region = "us-east-2a"
  }
}
resource "aws_route_table_association" "association-3" {
  subnet_id      = aws_subnet.pvt-subnet1.id
  route_table_id = aws_route_table.Private_rt_1.id
}
resource "aws_route_table_association" "association-4" {
  subnet_id      = aws_subnet.pvt-subnet2.id
  route_table_id = aws_route_table.Private_rt_1.id
}



##############################################################
#                       SECURITY GROUP
##############################################################
resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.my-vpc.id
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "http"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.InstanceTag}-SG"
  }
}
########################################################################
#                        EC2 Instance 
########################################################################
resource "aws_instance" "Ec2Instance" {
  ami                    = var.ami[1]
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]
  subnet_id              = aws_subnet.pub-subnet1.id
  key_name               = "cloud"
  instance_type          = "t2.micro"
  user_data              = file("bash.sh")
  tags = {
    Name = "${var.InstanceTag}-EC2-Instance"
  }
}
