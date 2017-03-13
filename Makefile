all: build

build:
	@docker build --tag=phpbcom/docker-redis .
