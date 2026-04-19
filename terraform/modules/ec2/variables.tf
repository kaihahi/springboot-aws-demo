variable "project" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "sg_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "rds_endpoint" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "s3_bucket" {
  type = string
}
