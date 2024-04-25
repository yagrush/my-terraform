init-p:
	docker-compose run --rm prepare_for_tfstate init

plan-p:
	docker-compose run --rm prepare_for_tfstate plan -var-file envs/dev/config.tfvars

apply-p:
	docker-compose run --rm prepare_for_tfstate apply -var-file envs/dev/config.tfvars

destroy-p:
	docker-compose run --rm prepare_for_tfstate destroy -var-file envs/dev/config.tfvars

####################################################

init-dev:
	docker-compose run --rm hogehoge init -backend-config envs/dev/backend.tfbackend -reconfigure

plan-dev:
	docker-compose run --rm hogehoge plan -var-file envs/dev/config.tfvars

apply-dev:
	docker-compose run --rm hogehoge apply -var-file envs/dev/config.tfvars

destroy-dev:
	docker-compose run --rm hogehoge destroy -var-file envs/dev/config.tfvars

run:
	docker-compose run --rm hogehoge ${C}

# env-list:
# 	docker-compose run --rm hogehoge env list

####################################################

lsd:
	docker container ls -a


####################################################

sh:
	docker container exec -it hogehoge ash

docker-prune:
	docker system prune -a
