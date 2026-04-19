output "endpoint" {
  value = aws_db_instance.this.endpoint
}

output "db_identifier" {
  value = aws_db_instance.this.id
}
