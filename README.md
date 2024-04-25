# my-terraform

terraformの実験場

terraformで
* tfstate管理をS3, tfstate_lock管理をDynamoDBに任せる
* S3バケットを作る
* lambda関数を登録する

## 前準備

1. AWSに以下の権限を持つユーザーを用意する（本当は厳密に絞る）
    * AmazonDynamoDBFullAccess
    * AmazonS3FullAccess
    * AWSLambda_FullAccess
    * IAMFullAccess
2. そのユーザーのアクセスキーを作成する
3. `~/.aws/credentials` に以下のように書く
(`~/.aws` はAWS CLIを使ったことがあると存在するはず なかったら自分で作る)
```
[hogehoge]
aws_access_key_id = <アクセスキー>
aws_secret_access_key = <シークレットアクセスキー>
region = ap-northeast-1
```
> `hogehoge` はAWSに接続する際の「プロファイル名」として後で使う
4. 以下を各自の状況に応じて編集する
    * `envs/dev/backend.tfbackend`
    * `config.tfvars`
5. tfstate管理用S3バケット、tfstate_lock管理用DynamoDBテーブルを作成する
```
make init-p
make plan-p
make apply-p
```


### 実行

#### S3作成

1. 以下を実行する
```
make init-dev
make plan-dev
make apply-dev
```
`Do you want to perform these actions?` と聞かれたら `yes` と入力する

2. エラーや問題がなければ、バケットが作成されていることを確認してみる

#### lambda関数登録

1. 以下を実行する
```
make init-foo
make plan-foo
make apply-foo
```
`Do you want to perform these actions?` と聞かれたら `yes` と入力する

2. エラーや問題がなければ、lambda関数が登録されていることを確認してみる


### 後始末

以下を実行すると全ての手順が巻き戻される
```
make destroy-foo
make destroy-dev
make destroy-p
```
`Do you really want to destroy all resources?` と聞かれたら `yes` と入力する
