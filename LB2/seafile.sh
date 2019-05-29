#!/bin/bash

# Updates herunterladen
sudo yum update -y

# Wget herunterladen
sudo yum install wget -y

# Benötigte Repositories herunterladen und installieren
sudo yum install epel-release -y
sudo rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro && sudo rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
sudo yum install python-imaging MySQL-python python-distribute python-memcached python-ldap python-urllib3 ffmpeg ffmpeg-devel python-requests -y

# Ufw installieren und einrichten
sudo yum install ufw -y
echo "y" | sudo ufw enable
sudo ufw allow from 10.0.2.2 to any port 22
echo "y" | sudo ufw delete 1    # Delete default allow any ssh
echo "y" | sudo ufw delete 3    # Delete default allow any sshv6
sudo ufw reload

# Seafile user erstellen und zu bentuzer wechseln
sudo useradd seafile
sudo su - seafile
mkdir seafile

# Download seafile
wget https://download.seadrive.org/seafile-server_7.0.0_x86-64.tar.gz -P /tmp
tar -xzvf /tmp/seafile-server_7.0.0_x86-64.tar.gz -C ~/seafile > /dev/null
~/seafile/seafile-server-7.0.0/setup-seafile-mysql.sh auto -n seafile-srv -i 10.0.2.15 -p 8082 -d /home/seafile/seafile/seafile-data/ -e 1 -o $db01 -t 3306 -u seafile -w $dbPassword -c ccnetdb -s seafiledb -b seahubdb

# Erklärung der benutzen Parameter
# auto
# -n servername
# -i serverip or dns name
# -p fileserver port
# -d seafile-dir
# -e 1 = Use exsiting dbs
# -o mysql-host
# -t mysql-port
# -u mysqlusername 
# -w mysql-password
# -c ccnet-db name
# -s seafile-db name
# -b seahub-db name

# Aus seafile user ausloggen
logout

# DB-Password file löschen
sudo rm -rf /etc/profile.d/db-passwd.sh

echo "Frontend setup script complete!"