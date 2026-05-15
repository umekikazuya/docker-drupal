.PHONY: init

init:
	docker compose build
	docker compose run --rm -u www-data app composer install
	docker composer up -d
