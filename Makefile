include .env
export

CURRENT_DATE := $(shell powershell -Command "Get-Date -Format 'yyyy-MM-dd'")
JDBC_URL := "jdbc:postgresql://${POSTGRES_HOST}/${POSTGRES_DB}"
JDBC_PROPERTIES := '{"user": "${POSTGRES_ACCOUNT}", "password": "${POSTGRES_PASSWORD}"}'

help:
	@echo ## postgres			- Run a Postgres container, including its inter-container network.

all: network postgres airflow

network:
	@docker network inspect de-network >/dev/null 2>&1 || docker network create de-network

postgres: postgres-create

postgres-create:
	@docker-compose -f ./docker/docker-compose-postgres.yml --env-file .env up -d
	@echo '__________________________________________________________'
	@echo 'Postgres container created at port ${POSTGRES_PORT}...'
	@echo '__________________________________________________________'
	@echo 'Postgres Docker Host    : ${POSTGRES_HOST}' &&\
		echo 'Postgres Account        : ${POSTGRES_ACCOUNT}' &&\
		echo 'Postgres password       : ${POSTGRES_PASSWORD}' &&\
		echo 'Postgres Db             : ${POSTGRES_DB}'
	@sleep 5
	@echo '==========================================================='

airflow: airflow-create

airflow-create:
	@docker-compose -f ./docker/docker-compose-airflow.yml --env-file .env up -d
	
clean:
	@powershell -Command "& .\helper\goodnight.ps1"