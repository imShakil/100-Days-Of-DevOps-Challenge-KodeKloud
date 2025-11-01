resource "aws_vpc" "vpc" {
  cidr_block = var.KKE_VPC_CIDR

  tags = {
    Name = "${var.prefix}-vpc"
  }
}

resource "aws_subnet" "subnet" {
  cidr_block              = var.KKE_SUBNET_CIDR
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.prefix}-subnet"
  }
}

resource "aws_security_group" "sg" {
  vpc_id      = aws_vpc.vpc.id
  name        = "${var.prefix}-sg"
  description = "Security group for EC2 instance"

  tags = {
    Name = "${var.prefix}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = var.KKE_VPC_CIDR
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.KKE_VPC_CIDR
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.sg.id
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}


data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "ec2" {
  subnet_id              = aws_subnet.subnet.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg.id]
  ami                    = data.aws_ami.amazon_linux.id

  tags = {
    Name = "${var.prefix}-ec2"
  }
}
