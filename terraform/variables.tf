variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "project" {
  description = "Project name prefix"
  type        = string
}

variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
}
variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}
