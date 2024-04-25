
run:
	docker-compose run --rm terraform ${C}

init-dev:
	docker-compose run --rm terraform init -backend-config envs/dev/backend.tf -reconfigure

plan-dev:
	docker-compose run --rm terraform plan -var-file envs/dev/config.tfvars

apply-dev:
	docker-compose run --rm terraform apply -var-file envs/dev/config.tfvars

destroy-dev:
	docker-compose run --rm terraform destroy -var-file envs/dev/config.tfvars

env-list:
	docker-compose run --rm terraform env list

lsd:
	docker container ls -a


####################################################

sh:
	docker container exec -it terraform ash

docker-prune:
	docker system prune -a
