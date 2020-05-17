provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "vpc" {
  cidr_block = "172.32.0.0/16"

  tags = {
    Name = "vpc_terraform"
  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw_terraform"
  }

}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "rt_public_terraform"
  }

}

resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "rt_private_terraform"
  }

}

resource "aws_subnet" "subnet_public" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "172.32.1.0/24"
  /*
  It's possible set the public ip option on the subnet or in the EC2 instance
  map_public_ip_on_launch = true
  */

  depends_on = [aws_route_table.rt_public]

  tags = {
    Name = "subnet_public_terraform"
  }

}

resource "aws_subnet" "subnet_private" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "172.32.2.0/24"

  depends_on = [aws_route_table.rt_private]

  tags = {
    Name = "subnet_private_terraform"
  }

}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.subnet_private.id
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_network_acl" "nacl" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = [aws_subnet.subnet_public.id, aws_subnet.subnet_private.id]

  tags = {
    Name = "nacl_terraform"
  }

}

resource "aws_network_acl_rule" "nacl_inbound_ssh" {
  network_acl_id = aws_network_acl.nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "nacl_outbound_ssh" {
  network_acl_id = aws_network_acl.nacl.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "nacl_inbound_http" {
  network_acl_id = aws_network_acl.nacl.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "nacl_outbound_http" {
  network_acl_id = aws_network_acl.nacl.id
  rule_number    = 110
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "sg_terraform"
  }

}

resource "aws_security_group_rule" "sg_inbound" {
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "sg_outbound" {
  type              = "egress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  to_port           = 80
  security_group_id = aws_security_group.sg.id
}