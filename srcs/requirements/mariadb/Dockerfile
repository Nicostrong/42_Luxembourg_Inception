FROM alpine:latest

RUN addgroup -S mysql && adduser -S mysql -G mysql
RUN apk update && apk add --no-cache mariadb mariadb-client bash su-exec
RUN mkdir -p /var/lib/mysql /run/mysqld /scripts \
 && chown -R mysql:mysql /var/lib/mysql /run/mysqld /scripts

COPY tools/setup_mariadb.sh /scripts/setup_mariadb.sh
COPY tools/entrypoint.sh /scripts/entrypoint.sh

COPY tools/mariadb.conf /etc/my.cnf.d/mariadb-server.cnf

RUN chmod -w /etc/my.cnf.d/mariadb-server.cnf

RUN chmod +x /scripts/*.sh

ENTRYPOINT ["/scripts/entrypoint.sh"]
