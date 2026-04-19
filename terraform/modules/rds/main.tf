resource "aws_db_subnet_group" "this" {
  name       = "${var.project}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.project}-db-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  identifier              = "${var.project}-db"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"

  # --- ストレージ ---
  allocated_storage       = 20
  storage_type            = "gp3"

  # 自動ストレージ拡張を禁止（勝手に増えて課金される事故を防ぐ）
  max_allocated_storage   = 20

  # --- ネットワーク ---
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [var.sg_id]
  publicly_accessible     = false

  # --- 課金事故防止設定 ---
  multi_az                = false                # 明示的に Single-AZ
  performance_insights_enabled = false           # PI 課金防止
  backup_retention_period = 0                    # バックアップ課金防止
  deletion_protection     = false                # 削除保護 OFF（個人開発向け）
  skip_final_snapshot     = true                 # 削除時のスナップショット課金防止

  # --- 認証 ---
  username                = var.db_username
  password                = var.db_password

  tags = {
    Name = "${var.project}-db"
  }
}
