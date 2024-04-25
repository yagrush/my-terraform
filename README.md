# my-terraform

terraformの実験場

terraformで
* S3バケットを作る

## 前準備

1. AWSにS3FullAccess権限を持つユーザーを用意する
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
4. `envs/dev/config.tfvars` を編集する


### 実行

1. 以下を実行する
```
make init-dev
```
```
make plan-dev
```
2. エラーや問題がなければ以下を実行する
```
make apply-dev
```
`Do you want to perform these actions?` と聞かれたら `yes` と入力する

3. エラーや問題がなければ、バケットが作成されていることを確認してみる


### 後始末

以下を実行するとバケットが削除され全ての手順が巻き戻される
```
make destroy-dev
```
`Do you really want to destroy all resources?` と聞かれたら `yes` と入力する
