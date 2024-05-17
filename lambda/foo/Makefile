up-bd:
	docker-compose up --build -d

up-bcd:
	docker-compose build --no-cache && docker-compose up -d

down:
	docker-compose down

log:
	docker-compose logs -f

sh-app:
	docker container exec -it foo bash

docker-prune:
	docker system prune -a

req:
	pip freeze > requirements.txt

venv-start:
	python -m venv .venv
	chmod 777 .venv/bin/activate
	source ./.venv/bin/activate
	@make pip-r

deactivate:
	deactivate

pip-r:
	pip install -r requirements.txt

# localのdockerで起動しているlambda関数をキックする
lam:
	curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"name": "higehige"}'

