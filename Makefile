# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nfordoxc <nfordoxc@42luxembourg.lu>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/03/31 07:43:50 by nfordoxc          #+#    #+#              #
#    Updated: 2025/03/31 07:45:09 by nfordoxc         ###   Luxembourg.lu      #
#                                                                              #
# **************************************************************************** #

# Nom du fichier Docker Compose
DOCKER_COMPOSE_FILE = docker-compose.yml

# Cibles
.PHONY: up down logs ps build restart clean

# Lancer les conteneurs en arrière-plan
up:
    docker-compose -f $(DOCKER_COMPOSE_FILE) up -d

# Arrêter les conteneurs
down:
    docker-compose -f $(DOCKER_COMPOSE_FILE) down

# Construire ou reconstruire les images Docker
build:
    docker-compose -f $(DOCKER_COMPOSE_FILE) build

# Afficher les logs en continu
logs:
    docker-compose -f $(DOCKER_COMPOSE_FILE) logs -f

# Afficher l'état des conteneurs
ps:
    docker-compose -f $(DOCKER_COMPOSE_FILE) ps

# Redémarrer les conteneurs
restart: down up

# Nettoyer les volumes et les réseaux
clean:
    docker-compose -f $(DOCKER_COMPOSE_FILE) down -v
