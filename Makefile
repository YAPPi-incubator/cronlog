SHELL := /bin/bash

.DEFAULT: help
.PHONY: help behat tests

help: ## prints this help
	@echo; echo "main commands:"
	@grep '@main' $(MAKEFILE_LIST) | egrep -h '^[a-zA-Z0-9_-]+:.*?## .*$$' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' | sed 's/^/  /g' | sort -k3,3 -k1,1 | sed 's/@main //g'
	@echo; echo "secondary commands:"
	@grep -v '@main' $(MAKEFILE_LIST) | egrep -h '^[a-zA-Z0-9_-]+:.*?## .*$$' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' | sed 's/^/  /g'
	@echo

project-start: ## @main run all containers in background
	@sudo docker-compose up -d

project-stop: ## @main stop and remove all containers running in background
	@sudo docker-compose down

project-restart: ## @main stop and start all containers
	@make project-stop
	@make project-start

tests: project-start behat ## @main run all tests

behat: behat-domain behat-e2e ## run all types of behat tests

behat-domain: ## run "domain" part of behat tests
	@sudo docker-compose exec app /bin/bash -c "cd /app && ./vendor/bin/behat --colors -vvv --tags=~e2e" 

behat-e2e: ## run "e2e" part of behat tests
	@sudo docker-compose exec app /bin/bash -c "cd /app && ./vendor/bin/behat --colors -vvv --tags=e2e"

