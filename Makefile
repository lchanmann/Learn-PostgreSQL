DATA_DIR ?= pg_data
PORT ?= 5433

initdb:
	if [ ! -d $(DATA_DIR) ]; then \
		initdb -D $(DATA_DIR); \
	fi

start:
	postgres -D $(DATA_DIR) -p $(PORT)

%_console:
	psql -p $(PORT) $*

run_%.sql: default_db
	psql -p $(PORT) -f $*.sql

default_db:
	createdb -p $(PORT) `whoami`
	touch default_db


.PHONY: initdb start
