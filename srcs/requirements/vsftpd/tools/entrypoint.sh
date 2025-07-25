#!/bin/bash

set -e

#	Check secrets exist
[ ! -f /run/secrets/ftp_pwd.txt ] && echo "❌ Missing ftp_pwd.txt secret" && exit 1

#	Injection of secrets
export FTP_PWD=$(cat /run/secrets/ftp_pwd.txt)

#	Check env variables
[ -z "$FTP_USER" ] && echo "❌ FTP_USER not set" && exit 
[ -z "$DOMAINE_NAME" ] && echo "❌ DOMAIN_NAME not set" && exit 1

# 	Create ftpuser
if ! id "$FTP_USER" &>/dev/null; then
    echo "👤 Creating FTP user: $FTP_USER"
    adduser -D -h /var/www/html "$FTP_USER"
    echo "$FTP_USER:$FTP_PWD" | chpasswd
    echo "$FTP_USER:$FTP_PWD"
fi

#	Add some right to use ftp with wordpress
chown -R "$FTP_USER:$FTP_USER" /var/www/html

sed -i "s/pasv_address=PLACEHOLDER/pasv_address=$DOMAINE_NAME/" /etc/vsftpd/vsftpd.conf

echo "🚀 Starting vsftpd server..."
exec vsftpd /etc/vsftpd/vsftpd.conf
