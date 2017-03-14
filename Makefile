all: build

build:
	@docker build --tag=gotfix/redis .
