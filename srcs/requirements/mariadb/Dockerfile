FROM alpine:latest

RUN apk update && apk add --no-cache mariadb mariadb-client bash su-exec
RUN getent group mysql || addgroup -S mysql
RUN mkdir -p    /var/lib/mysql  /run/mysqld         /scripts && \
    chown -R    mysql:mysql     /var/lib/mysql      /run/mysqld

COPY tools/setup_mariadb.sh /scripts/setup_mariadb.sh
COPY tools/entrypoint.sh    /scripts/entrypoint.sh
COPY tools/mariadb.conf     /etc/my.cnf.d/mariadb-server.cnf

RUN chmod +x    /scripts/*.sh   && \
    chown -R    mysql:mysql     /scripts

ENTRYPOINT ["/scripts/entrypoint.sh"]
