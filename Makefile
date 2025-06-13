# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nfordoxc <nfordoxc@42luxembourg.lu>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/03/31 07:43:50 by nfordoxc          #+#    #+#              #
#    Updated: 2025/06/13 15:57:10 by nfordoxc         ###   Luxembourg.lu      #
#                                                                              #
# **************************************************************************** #

DOCKER_COMPOSE_FILE = docker-compose.yml
STACK_NAME = 42_Luxembourg

.PHONY: up down logs ps ls build restart clean prune init check_secrets re

init:
	@docker swarm init || echo "⚠️ Swarm was already initialized."
	@docker build -t $(STACK_NAME)_inception_mariadb	./srcs/requirements/mariadb
	@docker build -t $(STACK_NAME)_inception_wordpress	./srcs/requirements/wordpress
	@docker build -t $(STACK_NAME)_inception_nginx		./srcs/requirements/nginx
	@echo "✅ Docker images are built."
	@docker info | grep "Swarm: active" || (echo "❌ Swarm is still inactive!" && exit 1)
	@echo "✅ Docker Swarm is enabled."

up:			init
	@docker stack deploy -c $(DOCKER_COMPOSE_FILE) $(STACK_NAME)

down:
	@docker stack rm $(STACK_NAME)
	@docker swarm leave --force

build:
	@docker build -t $(STACK_NAME)_inception_mariadb ./srcs/requirements/mariadb
	@docker build -t $(STACK_NAME)_inception_wordpress ./srcs/requirements/wordpress
	@docker build -t $(STACK_NAME)_inception_nginx ./srcs/requirements/nginx

logs:
	@docker service logs $(STACK_NAME)_mariadb
	@docker service logs $(STACK_NAME)_wordpress
	@docker service logs $(STACK_NAME)_nginx

ps:
	@docker stack ps $(STACK_NAME)

ls:
	@docker service ls

restart:
	@docker stack rm $(STACK_NAME)
	@sleep 2
	@docker stack deploy -c $(DOCKER_COMPOSE_FILE) $(STACK_NAME)

clean:		prune
	@docker network rm $(STACK_NAME)_inception_network || true
	@docker system prune -a --volumes -f
	@echo "✅\tAll unused volumes, networks and images have been deleted."

prune:
	@docker system prune -a --volumes -f
	@echo "✅\tAll unused volumes and networks have been deleted."
	@docker volume rm $(STACK_NAME)_mariadb_data || true
	@echo "✅\tMariaDB volume deleted."
	@docker volume rm $(STACK_NAME)_wordpress_data || true
	@echo "✅\tWordpress volume deleted."

reset-db:
	@docker volume rm $(STACK_NAME)_mariadb_data || true
	@echo "✅\tMariaDB volume deleted."

check_secrets:
	@docker secret ls

re:			down \
			clean \
			prune \
			up