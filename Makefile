# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicostrong <nicostrong@student.42.fr>      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/03/31 07:43:50 by nfordoxc          #+#    #+#              #
#    Updated: 2025/07/13 18:28:17 by nicostrong       ###   Luxembourg.lu      #
#                                                                              #
# **************************************************************************** #

COMPOSE_FILE	=	srcs/docker-compose.yml
SECRETS_DIR		=	secrets
ENV_FILE		=	srcs/.env

.PHONY: up setup  down logs build clean re fclean

up:					setup
	@echo "📦 Création et déploiement des containers..."
	@docker compose -f $(COMPOSE_FILE) up -d --build
	@$(MAKE) logs

setup:				secrets
	@echo "✅ Setup completed"

secrets:
	@echo "🔐 Checking of all secrets..."
	@if [ ! -d "$(SECRETS_DIR)" ] || [ ! -f "$(SECRETS_DIR)/db_root_pwd.txt" ]; then \
		echo "🔧 Creating of secrets..."; \
		srcs/generate_secrets.sh; \
	else \
		echo "✅ Secrets ready"; \
	fi

down:
	@echo "🧹 Arrêt des containers..."
	@docker compose -f $(COMPOSE_FILE) down

build:
	@echo "🔧 Construction des images..."
	@docker compose -f $(COMPOSE_FILE) build

logs:
	@echo "📜 Affichage des logs (Ctrl+C pour quitter)..."
	@docker compose logs -f $(COMPOSE_FILE)

clean:
	@echo "🧽 Nettoyage des volumes et ressources inutilisées..."
	@docker volume rm $(shell docker volume ls -qf name=inception) || true
	@docker system prune -a --volumes -f

re:					fclean \
					up

fclean:				down \
					clean
