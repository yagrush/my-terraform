FROM hashicorp/terraform:1.8

# lambda関数のdockerイメージを作成してECRに登録するのにdockerコマンドが要る
RUN apk update && \
apk add --no-cache docker-cli && \
apk add --no-cache docker-compose
