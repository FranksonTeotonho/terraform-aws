variable "aws_region" {
  default = "us-east-1"
}

variable "key_name" {
  default = "terraform"
}

variable "public_key_path" {
  default = "~/.ssh/terraform.pub"
}

variable "private_key_path" {
  default = "~/.ssh/terraform.pem"
}

variable "user_data_path" {
  default = "user-data.tpl"
}