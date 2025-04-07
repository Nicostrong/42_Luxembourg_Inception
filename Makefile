# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nfordoxc <nfordoxc@42.luxembourg.lu>       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/03/31 07:43:50 by nfordoxc          #+#    #+#              #
#    Updated: 2025/04/07 08:52:25 by nfordoxc         ###   Luxembourg.lu      #
#                                                                              #
# **************************************************************************** #

#	Name of the file docker-compose
DOCKER_COMPOSE_FILE = docker-compose.yml

#	Cibles
.PHONY: up down logs ps build restart clean prune init

#	Check if docker is installed
init:
	@which docker > /dev/null 2>&1 || (echo "Docker isn't installed!!" && exit 1)
	@which docker-compose > /dev/null 2>&1 || (echo "Docker Compose isn't installed!!" && exit 1)
	@echo "✅	Docker and Docker Compose are installed."


#	run the docker-compose in back-ground
up:			init
	sudo docker-compose -f $(DOCKER_COMPOSE_FILE) up -d

#	Stop all containers
down:
	sudo docker-compose -f $(DOCKER_COMPOSE_FILE) down

#	build or rebuild the containers
build:
	sudo docker-compose -f $(DOCKER_COMPOSE_FILE) build

#	Show all logs of the containers
logs:
	sudo docker-compose -f $(DOCKER_COMPOSE_FILE) logs -f

#	show the statement of all containers
ps:
	sudo docker-compose -f $(DOCKER_COMPOSE_FILE) ps

#	restart all containers
restart:	down up

#	Clean all volumes and networks
clean:
	sudo docker-compose -f $(DOCKER_COMPOSE_FILE) down -v

#	Delete all volumes and networks
prune:
	sudo docker system prune -a --volumes -f
	@echo "✅	All unused volumes and networks have been deleted."