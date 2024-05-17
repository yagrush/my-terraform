resource "aws_ecr_repository" "foo" {
  name = var.ecr_name_foo
  force_delete = true
}

data "aws_ecr_authorization_token" "token" {}

resource "null_resource" "image_push" {
  provisioner "local-exec" {
    command = <<-EOF
      docker build --platform linux/amd64 foo -t ${aws_ecr_repository.foo.repository_url}:latest; \
      docker login -u AWS -p ${data.aws_ecr_authorization_token.token.password} ${data.aws_ecr_authorization_token.token.proxy_endpoint}; \
      docker push ${aws_ecr_repository.foo.repository_url}:latest
    EOF
  }
}

