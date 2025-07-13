#   os of the container not the latest
FROM alpine:3.21

#   update and upgrade of apk
RUN apk update && apk upgrade

#   installing some programs
RUN apk add --no-cache mariadb
RUN apk add --no-cache mariadb-client
RUN apk add --no-cache bash
RUN apk add --no-cache su-exec
RUN apk add --no-cache vim

#   add group
RUN getent group mysql || addgroup -S mysql
RUN mkdir -p /var/lib/mysql
RUN mkdir -p /run/mysqld
RUN mkdir -p /scripts
RUN chown -R mysql:mysql
RUN chown -R /var/lib/mysql
RUN chown -R /run/mysqld

#   copy files
COPY tools/setup_mariadb.sh /scripts/setup_mariadb.sh
COPY tools/entrypoint.sh    /scripts/entrypoint.sh
COPY tools/mariadb.conf     /etc/my.cnf.d/mariadb-server.cnf

RUN chmod +x /scripts/*.sh 
RUN chown -R mysql:mysql /scripts

ENTRYPOINT ["/scripts/entrypoint.sh"]
