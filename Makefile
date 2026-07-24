COMPOSE_FILE = srcs/docker-compose.yml
DATA_DIR = /home/khaled/data

all: setup
	sudo docker compose -f $(COMPOSE_FILE) up -d --build

setup:
	sudo mkdir -p $(DATA_DIR)/db
	sudo mkdir -p $(DATA_DIR)/wordpress
	sudo mkdir -p $(DATA_DIR)/static_website
	sudo cp -f srcs/requirements/bonus/Static_website/static.html $(DATA_DIR)/static_website/index.html
	@if ! grep -q "khaled.42.fr" /etc/hosts; then \
		echo "127.0.0.1 khaled.42.fr" | sudo tee -a /etc/hosts; \
	fi

down:
	sudo docker compose -f $(COMPOSE_FILE) down

stop:
	sudo docker compose -f $(COMPOSE_FILE) stop

clean: down
	sudo docker image prune -f

fclean:
	sudo docker compose -f $(COMPOSE_FILE) down -v
	sudo docker system prune -af
	sudo docker volume prune -f
	sudo rm -rf $(DATA_DIR)

re: fclean all

.PHONY: all setup down stop clean fclean re