variable "key_name" {
  description = "Key's name"
  type = string
}

variable "public_key_path" {
  description = "Public key's path"
  type = string
}

variable "user_data_path" {
  description = "script's path"
  type = string
}

variable "subnet_id" {
  description = "subnet id"
  type = string
}

variable "security_group_id" {
  description = "security group id"
  type = string
}