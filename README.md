# Spring Boot APP on AWS with Terraform

EC2、VPC、RDS、S3で構築したシンプルなメモアプリケーションとなります。
Terraform を使うことで、AWS リソースをコードとして管理し、同じ構成をいつでも再現できるようにしています。
Spring Bootアプリのjarファイルは自動構築時にS3 バケットに格納され、EC2の起動時にS3 バケットから取得・実行まで自動で行われるようにしているため、terraform applyが完了した時点でアプリが動く状態になります。

---

## 🚀 概要

- EC2（Amazon Linux 2023）で Spring Boot を常時稼働
- RDS は Private Subnet に配置し、EC2 からのみアクセス可能
- S3 に JAR を配置し、EC2 起動時に自動ダウンロード
- VPC は 2AZ 構成（Public / Private Subnet）※使用しているAZは1つのみ
- Terraform による完全 IaC 化

---

## 🏗 構成図

![architecture](./architecture.png)

---

## 🔧 技術スタック

- AWS
	EC2 (Amazon Linux 2023)
	RDS (MySQL)
	S3
	VPC / Subnet / IGW / Route Table
	IAM（EC2 → S3 アクセス用）
- Terraform
- Spring Boot

---

## 📁 ディレクトリ構成
```
.
├── aws-sample/                          Spring Bootアプリのソースコードを格納しています。（配下の階層については割愛します）
├── terraform/
│      ├── main.tf
│      ├── variables.tf
│      ├── outputs.tf
│      ├── terraform.tfvars             DBのパスワードなどはこのファイルから渡しています。（値は置き換えてコミット）
│      ├── build/
│      │  └── libs/
│      │       └── app.jar             こちらにjarファイルを配置します。（githubへのコミットはなし）
│      └── modules/
│          ├── vpc/
│          │   ├── main.tf
│          │   ├── variables.tf
│          │   └── outputs.tf
│          ├── ec2/
│          │   ├── main.tf
│          │   ├── variables.tf
│          │   ├── outputs.tf
│          │   └── user-data.sh
│          ├── rds/
│          │   ├── main.tf
│          │   ├── variables.tf
│          │   └── outputs.tf
│          ├── security/
│          │  ├── main.tf
│          │  ├── variables.tf
│          │  └── outputs.tf
│          └── S3/
│              ├── main.tf
│              ├── variables.tf
│              └── outputs.tf
├── .gitignore
├── architecture.png                    構成図
└── README.md
```

---

## 📡 詳細（記載途中。アプリの仕様の詳細や動作確認の方法まで記載予定です。）

VPC  
アプリケーション専用のネットワークを作成し、その中に EC2 と RDS を配置しています。

サブネット構成

EC2：パブリックサブネット

RDS：プライベートサブネット
外部から直接 DB にアクセスできないようにし、EC2 経由でのみ通信可能な構成です。
※サブネットは、2つのアベイラビリティゾーンにそれぞれパブリックサブネットとプライベートサブネットを作成しましたが、RDSはマルチAZ配置にすると料金が発生するため、シングルAZで配置しました。（セオリー的にはマルチAZ配置にすべきですが）

EC2（Amazon Linux）  
Spring Boot アプリケーションを JAR として配置し、
java -jar により本番プロファイルで起動しています。
アプリは 8080 番ポートで待ち受けています。

RDS（MySQL）  
アプリケーション用のデータベースを作成し、
Spring Boot の JPA/Hibernate によりテーブルが自動生成されます。

セキュリティグループ

EC2：HTTP(8080) を外部に公開
     自分のPCのIPからのみ、SSH（ポート22）通信を許可

RDS：EC2 からの MySQL(3306) のみ許可

アプリケーション構成

GET /api/memos：登録済みメモの一覧取得

POST /api/memos：メモの登録（JSON）
データは RDS に保存され、ブラウザから GET で確認できます。

本番環境の設定
本番用の設定は application-prod.properties に分離（Terraformによって自動作成）し、
以下の情報を外部ファイルとして管理しています。
（ローカル用のapplication-local.propertiesは、ローカルのDocker環境で動作確認する際に使用しました。）

DB 接続 URL

DB ユーザー名

DB パスワード

Hibernate 設定

ポート番号

GitHub には 機密情報を<パスワード>のように置き換えて配置しています。

動作確認
ブラウザから GET リクエストを送信すると、RDS に保存されたデータが JSON として返却されます。

POST は curl や API クライアント（Postman など）から JSON を送信することで登録できます。