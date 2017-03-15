all: build

build:
	@docker build --tag=quay.io/gotfix/redis .
