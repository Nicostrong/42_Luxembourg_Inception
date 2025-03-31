FROM alpine:latest

RUN apk update && apk add --no-cache mariadb mariadb-server

COPY conf/setup.sql /docker-entrypoint-initdb.d/setup.sql

CMD ["mysqld"]

ENTRYPOINT [ "./tools/entrypoint.sh" ]