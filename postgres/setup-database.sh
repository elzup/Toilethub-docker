#!/bin/bash

TEST=`psql -U postgres <<- EOSQL
   SELECT 1 FROM pg_database WHERE datname='$DB_NAME';
EOSQL`

echo "******CREATING DOCKER DATABASE******"

psql -U postgres <<- EOSQL
CREATE ROLE $DB_USER WITH LOGIN ENCRYPTED PASSWORD '${DB_PASS}' CREATEDB;
EOSQL

psql -U postgres <<- EOSQL
CREATE DATABASE $DB_NAME WITH OWNER $DB_USER TEMPLATE template0 ENCODING 'UTF8';
EOSQL

psql -U postgres <<- EOSQL
GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
EOSQL

set -e

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"


# Load PostGIS into both template_database and $POSTGRES_DB
for DB in $DB_NAME "$POSTGRES_DB"; do
	echo "Loading PostGIS extensions into $DB"
	"${psql[@]}" --dbname="$DB" <<-'EOSQL'
		CREATE EXTENSION IF NOT EXISTS postgis;
		CREATE EXTENSION IF NOT EXISTS postgis_topology;
		CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;
		CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder;
EOSQL
done



gosu postgres pg_ctl start -w && gosu postgres psql -U "$DB_USER" -d "$DB_NAME" -f "$DB_PG_DUMP_FILE" && gosu postgres pg_ctl stop -w && /bin/rm -f ${DB_PG_DUMP_FILE};
# gosu postgres pg_ctl start -w && gosu postgres psql -U "$DB_USER" -d "$DB_NAME" -f "$DB_PG_DUMP_FILE" && gosu postgres pg_ctl stop -w && /bin/rm -f ${DB_PG_DUMP_FILE}

echo ""
echo "******DOCKER DATABASE CREATED******"


