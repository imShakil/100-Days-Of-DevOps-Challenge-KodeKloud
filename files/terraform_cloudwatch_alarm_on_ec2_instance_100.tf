resource "aws_sns_topic" "sns_topic" {
    name = "${var.prefix}-sns-topic"
}

resource "tls_private_key" "rsa_key" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "aws_key_pair" "ssh_public_key" {
  key_name       = "${var.prefix}-ssh-key"
  public_key = tls_private_key.rsa_key.public_key_openssh
}

resource "local_file" "ssh_private_key" {
  content = tls_private_key.rsa_key.private_key_pem
  filename = "ssh-private-key.pem"
  file_permission = "0400"
}

resource "aws_vpc" "kk_vpc" {
    cidr_block = "10.10.0.0/16"
    
    tags = {
        Name = "${var.prefix}-vpc"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.kk_vpc.id

    tags = {
        Name = "${var.prefix}-igw"
    }  
}

resource "aws_route_table" "kk_rt" {
    vpc_id = aws_vpc.kk_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "${var.prefix}-rt"
    }
}

resource "aws_subnet" "kk_subnet" {
    vpc_id = aws_vpc.kk_vpc.id
    cidr_block = "10.10.0.0/24"
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.prefix}-subnet"
    }
}

resource "aws_route_table_association" "kk_rta" {
    subnet_id = aws_subnet.kk_subnet.id
    route_table_id = aws_route_table.kk_rt.id
}

resource "aws_security_group" "kk_sg" {
    name = "${var.prefix}-security-group"
    vpc_id = aws_vpc.kk_vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.prefix}-security-group"
    }
}

resource "aws_instance" "ec2_instance" {
    ami = "ami-0c02fb55956c7d316"
    instance_type = "t2.micro"
    key_name = aws_key_pair.ssh_public_key.key_name
    subnet_id = aws_subnet.kk_subnet.id
    vpc_security_group_ids = [aws_security_group.kk_sg.id]
    associate_public_ip_address = true

    tags = {
        Name = "${var.prefix}-ec2"
    }
}

resource "aws_cloudwatch_metric_alarm" "cw_alarm" {
    alarm_name = "${var.prefix}-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = 1
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = 300
    statistic = "Average"
    threshold = 90

    dimensions = {
      InstanceId = aws_instance.ec2_instance.id
    }

    alarm_actions = [aws_sns_topic.sns_topic.arn]
}
