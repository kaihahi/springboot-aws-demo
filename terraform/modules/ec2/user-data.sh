#!/bin/bash
yum update -y
yum install -y java-17-amazon-corretto
yum install -y awscli

mkdir -p /home/ec2-user/app
cd /home/ec2-user/app

# --- application-prod.properties を自動生成 ---
cat <<EOF > application-prod.properties
spring.datasource.url=jdbc:mysql://${rds_endpoint}:3306/appdb
spring.datasource.username=${db_username}
spring.datasource.password=${db_password}
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false
server.port=8080
EOF

# --- jar を S3 から取得 ---
aws s3 cp s3://${s3_bucket}/app.jar /home/ec2-user/app/app.jar

# --- systemd 登録 ---
cat <<EOF > /etc/systemd/system/app.service
[Unit]
Description=Spring Boot App
After=network.target

[Service]
User=ec2-user
ExecStart=/usr/bin/java -jar /home/ec2-user/app/app.jar --spring.profiles.active=prod
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable app
systemctl start app
