# S3 上の静的 HTML を CloudFront 経由で配信するサンプル

## 前提となるリソース

- カスタムドメインの払い出しに使用する DNS 解決可能な Route53

## 作成する主なリソース

- CloudFront
- ACM
- S3

## 実行方法

1. params.tfvars ファイルを作成する

   ```
   aws_access_key         = "【Terraformの実行に使用するIAMユーザーのアクセスキー】"
   aws_secret_key         = "【Terraformの実行に使用するIAMユーザーのシークレットキー】"
   parent_domain_name     = "【既存のDNS解決可能なRoute 53のドメイン名。example.comなど】"
   sub_domain_name_prefix = "【サブドメインの先頭部分。test.example.comならtestの部分】"
   ```

2. terraform init, apply を実行する

   ```bash
   cd terraform
   terraform init
   terraform apply --var-file params.tfvars
   ```
