FROM alpine:latest

RUN apk update && apk add --no-cache mariadb mariadb-client bash vim

COPY tools/setup_db.sh /setup_db.sh
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /setup_db.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
