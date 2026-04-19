variable "project" {
  description = "Project name prefix"
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs for RDS"
  type        = list(string)
}

variable "sg_id" {
  description = "RDS security group ID"
  type        = string
}

variable "db_username" {
  description = "Master username"
  type        = string
}

variable "db_password" {
  description = "Master password"
  type        = string
  sensitive   = true
}
