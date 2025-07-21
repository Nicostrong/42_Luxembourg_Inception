# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicostrong <nicostrong@student.42.fr>      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/03/31 07:43:50 by nfordoxc          #+#    #+#              #
#    Updated: 2025/07/18 09:56:58 by nicostrong       ###   Luxembourg.lu      #
#                                                                              #
# **************************************************************************** #

COMPOSE_FILE		=	srcs/docker-compose.yml
SECRETS_DIR			=	secrets
ENV_FILE			=	srcs/.env

.PHONY: up setup down logs restart clean re fclean

up:					setup
	@echo "📦 Creation and deployment of containers ..."
	@docker compose -f $(COMPOSE_FILE) up -d --build

setup:				secrets
	@sudo mkdir -m 775 /home/nfordoxc/data
	@sudo mkdir -m 775 /home/nfordoxc/data/mariadb
	@sudo mkdir -m 775 /home/nfordoxc/data/portainer
	@sudo mkdir -m 775 /home/nfordoxc/data/redis
	@sudo mkdir -m 775 /home/nfordoxc/data/wordpress
	@sudo cp -dR srcs/static /home/nfordoxc/data/wordpress
	@echo "✅ Setup completed"

secrets:
	@echo "🔐 Checking of all secrets ..."
	@if [ ! -d "$(SECRETS_DIR)" ] || [ $$(find "$(SECRETS_DIR)" -maxdepth 1 -type f -name "*.txt" | wc -l) -ne 6 ]; then \
        echo "🔧 Creating of secrets ..."; \
        ./srcs/generate_secrets.sh; \
    else \
        echo "✅ All 6 secrets are ready"; \
    fi

down:
	@echo "🛑 down all containers ..."
	@docker compose -f $(COMPOSE_FILE) stop

restart:
	@echo "♻️ restart all containers ..."
	@docker compose -f $(COMPOSE_FILE) restart

logs:
	@echo "📜 Show all logs (Ctrl+C to quit) ..."
	@docker compose -f $(COMPOSE_FILE) logs -f

clean:
	@echo "🧹 Delete secrets ..."
	@rm -dRf ./secrets
	@echo "🧽 Cleanning of all volumes ..."
	@docker volume rm $(shell docker volume ls -qf name=srcs) || true
	@docker system prune -a --volumes -f
	@sudo rm -dRf /home/nfordoxc/data

re:					fclean \
					up

fclean:				down \
					clean
