#!/bin/bash

service mariadb start

sh ./setup_mariadb.sh

exec tail -f /dev/null