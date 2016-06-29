FROM postgres

MAINTAINER Chris de Kok <chris.de.kok@gmail.com>
MAINTAINER Mike Dillon <mike@appropriate.io>

ENV DB_NAME toilethub_db
ENV DB_USER elzup
ENV DB_PASS password
ENV DB_PG_DUMP_FILE /tmp/db.sql

ENV POSTGIS_MAJOR 2.2
ENV POSTGIS_VERSION 2.2.2+dfsg-1.pgdg80+1
RUN apt-get update \
      && apt-get install -y --no-install-recommends \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
           postgis=$POSTGIS_VERSION \
      && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /docker-entrypoint-initdb.d
# COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/postgis.sh


ADD setup-database.sh /docker-entrypoint-initdb.d/
ADD db.sql /tmp/db.sql
RUN chmod 755 /docker-entrypoint-initdb.d/setup-database.sh
# RUN sh /docker-entrypoint-initdb.d/setup-database.sh
