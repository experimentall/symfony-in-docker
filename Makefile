# Executables (local)
DOCKER_COMP = docker-compose

# Docker containers
PHP_CONT = $(DOCKER_COMP) exec php

# Executables
PHP      = $(PHP_CONT) php
COMPOSER = $(PHP_CONT) composer
SYMFONY  = $(PHP_CONT) bin/console
PHP_BASH = $(PHP_CONT) /bin/bash -c

# Misc
.DEFAULT_GOAL = help
.PHONY        = help build up start down logs sh bash composer vendor sf cc create-db-pgsql create-db-mysql create-db-sqlite phpunit-i phpunit-f phpunit-u phpunit-coverage phpcs phpstan

## —— 🎵 🐳 The Symfony Docker Makefile 🐳 🎵 ——————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Docker 🐳 ————————————————————————————————————————————————————————————————
build: ## Builds the Docker images
	@$(DOCKER_COMP) build --pull --no-cache

up: ## Start the docker hub in detached mode (no logs)
	@$(DOCKER_COMP) up --detach

start: build up ## Build and start the containers

down: ## Stop the docker hub
	@$(DOCKER_COMP) down --remove-orphans

logs: ## Show live logs
	@$(DOCKER_COMP) logs --tail=0 --follow

sh: ## Connect to the PHP FPM container
	@$(PHP_CONT) sh

bash: ## Bash in php-apache container
	@$(PHP_CONT) /bin/bash

## —— Composer 🧙 ——————————————————————————————————————————————————————————————
composer: ## Run composer, pass the parameter "c=" to run a given command, example: make composer c='req symfony/orm-pack'
	@$(eval c ?=)
	@$(COMPOSER) $(c)

vendor: ## Install vendors according to the current composer.lock file
vendor: c=install --prefer-dist --no-dev --no-progress --no-scripts --no-interaction
vendor: composer

## —— Symfony 🎵 ———————————————————————————————————————————————————————————————
sf: ## List all Symfony commands or pass the parameter "c=" to run a given command, example: make sf c=about
	@$(eval c ?=)
	@$(SYMFONY) $(c)

cc: c=c:c ## Clear the cache
cc: sf

create-db-pgsql: ## Sf doctrine:database:create --connection=pgsql
	@$(SYMFONY) 'doctrine:database:create --if-not-exists --no-interaction --connection=pgsql'
create-db-mysql: ## Sf doctrine:database:create --connection=mysql
	@$(SYMFONY) 'doctrine:database:create --if-not-exists --no-interaction --connection=mysql'
create-db-sqlite: ## Sf doctrine:database:create --connection=sqlite
	@$(SYMFONY) 'doctrine:database:create --if-not-exists --no-interaction --connection=sqlite'

## —— Tests ✅ ———————————————————————————————————————————————————————————————
phpunit-i: ## Run integration tests
	@$(PHP_BASH) 'bin/phpunit -c phpunit-i.xml'

phpunit-f: ## Run functional tests
	@$(PHP_BASH) 'bin/phpunit -c phpunit-f.xml'

phpunit-u: ## Run unit tests
	@$(PHP_BASH) 'bin/phpunit -c phpunit-u.xml'

phpunit-coverage: ## Generate code coverage
	@$(PHP_BASH) 'bin/phpunit --coverage-html coverage -c phpunit-u.xml'

phpcs: ## Run phpcs
	@$(PHP_BASH) 'vendor/bin/php-cs-fixer fix src --dry-run --diff --config=.php-cs-fixer.dist.php'

phpstan: ## Run phpstan
	@$(PHP_BASH) 'vendor/bin/phpstan analyse'
