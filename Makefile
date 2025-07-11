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

COMPOSE_FILE = docker-compose.yml

.PHONY: up down logs build clean re fclean

up:
	@echo "📦 Création et déploiement des containers..."
	@docker-compose -f $(COMPOSE_FILE) up -d --build
	@$(MAKE) logs

down:
	@echo "🧹 Arrêt des containers..."
	@docker-compose -f $(COMPOSE_FILE) down

build:
	@echo "🔧 Construction des images..."
	@docker-compose -f $(COMPOSE_FILE) build

logs:
	@echo "📜 Affichage des logs (Ctrl+C pour quitter)..."
	@docker-compose logs -f

clean:
	@echo "🧽 Nettoyage des volumes et ressources inutilisées..."
	@docker volume rm $(shell docker volume ls -qf name=inception) || true
	@docker system prune -a --volumes -f

re: fclean up

fclean: down clean