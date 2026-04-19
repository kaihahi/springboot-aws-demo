resource "aws_s3_bucket" "this" {
  bucket = "${var.project}-app-bucket"

  tags = {
    Name = "${var.project}-app-bucket"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "app_jar" {
  bucket = aws_s3_bucket.this.bucket
  key    = "app.jar"
  source = "${path.module}/../../build/libs/app.jar"
  etag   = filemd5("${path.module}/../../build/libs/app.jar")
}
