module "ec2" {
  source = "./modules/aws-ec2"

  key_name          = var.key_name
  public_key_path   = var.public_key_path
  user_data_path    = var.user_data_path
  subnet_id         = aws_subnet.subnet_public.id
  security_group_id = aws_security_group.sg.id
}