resource "tls_private_key" "rsa_private_key" {
  algorithm = "RSA"
  rsa_bits  = 3072
}

resource "aws_key_pair" "kp" {
  key_name   = "${var.prefix}-kp"
  public_key = tls_private_key.rsa_private_key.public_key_openssh
}

data "aws_vpc" "default" {
  default = true
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_instance" "ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.kp.key_name
  vpc_security_group_ids = [data.aws_security_group.default.id]

  tags = {
    Name = "${var.prefix}-ec2"
  }

}

output "ec2_info" {
  value = {
    public_ip  = aws_instance.ec2.public_ip
    private_ip = aws_instance.ec2.private_ip
  }
}