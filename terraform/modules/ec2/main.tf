# --- IAM Role（EC2 → S3 読み取り用）---

resource "aws_iam_role" "ec2_role" {
  name = "ec2-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "s3_read_policy" {
  name = "s3-read-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:ListBucket"
      ]
      Resource = [
        "arn:aws:s3:::${var.s3_bucket}",
        "arn:aws:s3:::${var.s3_bucket}/*"
      ]
    }]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# 最新のamiを取得
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "this" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  key_name               = var.key_name

  user_data = templatefile("${path.module}/user-data.sh", {
    rds_endpoint = var.rds_endpoint
    db_username  = var.db_username
    db_password  = var.db_password
    s3_bucket    = var.s3_bucket
  })

  tags = {
    Name = "${var.project}-ec2"
  }
}
