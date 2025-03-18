PROJECT_NAME="$(shell basename "$(PWD)")"
PROJECT_DIR="$(shell pwd)"
DOCKER_COMPOSE="$(shell which docker-compose)"
DOCKER="$(shell which docker)"
CONTAINER_PHP="php-unit"

init: generate-env up

sleep-5:
	sleep 5

up:
	docker-compose  --env-file .env.local up --build -d

down:
	docker-compose  --env-file .env.local down --remove-orphans


generate-env:
	@if [ ! -f .env.local ]; then \
		cp .env .env.local && \
		sed -i "s/^POSTGRES_PASSWORD=/POSTGRES_PASSWORD=$(shell openssl rand -hex 8)/" .env.local; \
	fi

bash:
	${DOCKER_COMPOSE} exec -it ${CONTAINER_PHP} /bin/bash

ps:
	${DOCKER_COMPOSE} ps

logs:
	${DOCKER_COMPOSE} logs -f

ci:
	${DOCKER_COMPOSE} exec ${CONTAINER_PHP} composer install --no-interaction

m-create:
	${DOCKER_COMPOSE} exec ${CONTAINER_PHP} bin/console doctrine:database:create --if-not-exists -n

m-list:
	${DOCKER_COMPOSE} exec ${CONTAINER_PHP} bin/console doctrine:migrations:list

m-diff:
	${DOCKER_COMPOSE} exec ${CONTAINER_PHP} bin/console doctrine:migrations:diff

m-up:
	${DOCKER_COMPOSE} exec ${CONTAINER_PHP} bin/console doctrine:migrations:migrate

m-prev:
	${DOCKER_COMPOSE} exec ${CONTAINER_PHP} bin/console doctrine:migrations:migrate prev

cc:
	${DOCKER_COMPOSE} exec ${CONTAINER_PHP} bin/console cache:clear
