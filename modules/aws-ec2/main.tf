provider "template" {
  version = "2.1.2"
}

resource "aws_key_pair" "ssh_key" {
    key_name   = var.key_name
    public_key = file(var.public_key_path)
  }

  data "template_file" "init" {
    template = file(var.user_data_path)

    vars = {
      my_id = "123"
    }

  }

  resource "aws_instance" "instance" {
    key_name                    = aws_key_pair.ssh_key.key_name
    ami                         = "ami-098f16afa9edf40be"
    instance_type               = "t2.micro"
    subnet_id                   = var.subnet_id
    vpc_security_group_ids      = [var.security_group_id]
    associate_public_ip_address = true
    user_data                   = data.template_file.init.rendered

    tags = {
      Name = "instance_terraform"
    }

  }