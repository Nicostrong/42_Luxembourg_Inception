FROM alpine:latest

RUN apk update && apk add --no-cache mariadb mariadb-client bash vim

COPY tools/setup_mariadb.sh /setup_mariadb.sh
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /setup_mariadb.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
