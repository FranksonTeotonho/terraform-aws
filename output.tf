output "vpc_public_subnets" {
  description = "public subnet id"
  value       = aws_subnet.subnet_public.id
}

output "EC2_id" {
  description = "EC2 id"
  value       = module.ec2.EC2_id
}