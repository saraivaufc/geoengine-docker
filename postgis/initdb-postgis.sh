psql -U admin -d $POSTGRES_DB -c 'create extension postgis;'
psql -U admin -d $POSTGRES_DB -c 'create extension hstore;'