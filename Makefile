init-lambda:
	docker-compose run --rm lambda init -backend-config envs/dev/lambda_foo.tfbackend -reconfigure

plan-lambda:
	docker-compose run --rm lambda plan -var-file envs/dev/config.tfvars

apply-lambda:
	docker-compose run --rm lambda apply -var-file envs/dev/config.tfvars

destroy-lambda:
	docker-compose run --rm lambda destroy -var-file envs/dev/config.tfvars

####################################################

init-p:
	docker-compose run --rm prepare_for_tfstate init

plan-p:
	docker-compose run --rm prepare_for_tfstate plan -var-file envs/dev/config.tfvars

apply-p:
	docker-compose run --rm prepare_for_tfstate apply -var-file envs/dev/config.tfvars

destroy-p:
	docker-compose run --rm prepare_for_tfstate destroy -var-file envs/dev/config.tfvars

####################################################

init-s3:
	docker-compose run --rm s3 init -backend-config envs/dev/s3.tfbackend -reconfigure

plan-s3:
	docker-compose run --rm s3 plan -var-file envs/dev/config.tfvars

apply-s3:
	docker-compose run --rm s3 apply -var-file envs/dev/config.tfvars

destroy-s3:
	docker-compose run --rm s3 destroy -var-file envs/dev/config.tfvars

run:
	docker-compose run --rm s3 ${C}

lsd:
	docker container ls -a

sh:
	docker container exec -it s3 ash

docker-prune:
	docker system prune -a
