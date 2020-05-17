output "EC2_id" {
  description = "EC2 id"
  value       = aws_instance.instance.id
}