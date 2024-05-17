# serverless-scheduled-batch-by-terraform

terraformで
* tfstate管理をS3, tfstate_lock管理をDynamoDBに任せる
* S3バケットを作る
* ECRにlambdaのdockerイメージを登録する
* S3にオブジェクトを書き込むlambda関数を作成する
* EventBridgeで毎分lambda関数を実行するようスケジューリングする

## 前準備

1. AWSに以下の権限を持つユーザーを用意する（本当は厳密に絞る）
    * AmazonDynamoDBFullAccess
    * AmazonS3FullAccess
    * AWSLambda_FullAccess
    * IAMFullAccess
    * CloudWatchLogsFullAccess
    * AmazonElasticContainerRegistryPublicFullAccess
    * AmazonEventBridgeFullAccess
    * ecr.*
```
   {
   "Version": "2012-10-17",
   "Statement": [
       {
           "Sid": "VisualEditor0",
           "Effect": "Allow",
           "Action": [
               "ecr:*"
           ],
           "Resource": "*"
       }
   ]
}
```

1. そのユーザーのアクセスキーを作成する
2. `~/.aws/credentials` に以下のように書く
(`~/.aws` はAWS CLIを使ったことがあると存在するはず なかったら自分で作る)
```
[hogehoge]
aws_access_key_id = <アクセスキー>
aws_secret_access_key = <シークレットアクセスキー>
region = ap-northeast-1
```
> `hogehoge` はAWSに接続する際の「プロファイル名」として後で使う
1. 以下を各自の状況に応じて編集する
    * `envs/dev/lambda_foo.tfbackend`
    * `envs/dev/backend.tfbackend`
    * `config.tfvars`
2. tfstate管理用S3バケット、tfstate_lock管理用DynamoDBテーブルを作成する
```
make init-p
make plan-p
make apply-p
```


### 実行

#### S3作成

1. 以下を実行する
```
make init-s3
make plan-s3
make apply-s3
```
`Do you want to perform these actions?` と聞かれたら `yes` と入力する

2. エラーや問題がなければ、バケットが作成されていることを確認してみる

#### lambda関数登録

1. 以下を実行する
```
make init-lambda
make plan-lambda
make apply-lambda
```
`Do you want to perform these actions?` と聞かれたら `yes` と入力する

2. エラーや問題がなければ、lambda関数が登録されていることを確認してみる


### 後始末

以下を実行すると全ての手順が巻き戻される
```
make destroy-lambda
make destroy-s3
make destroy-p
```
`Do you really want to destroy all resources?` と聞かれたら `yes` と入力する
