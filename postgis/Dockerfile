FROM postgres:11.4

MAINTAINER Agrosatelite <www.agrosatelite.com.br>

ENV LANG en_US.UTF-8  

ENV LANGUAGE en_US:en  

ENV LC_ALL en_US.UTF-8 

RUN apt-get update && apt-get install -y postgresql-11-postgis-2.5 postgis

RUN mkdir -p /docker-entrypoint-initdb.d

COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/postgis.sh

RUN chmod a+x /docker-entrypoint-initdb.d/postgis.sh