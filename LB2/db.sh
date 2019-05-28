#!/bin/bash

# Updates herunterladen
sudo yum update -y

# Wget herunterladen für nächsten befehl
sudo yum install -y wget

# Benötigte Repositories herunterladen und installieren
sudo yum install epel-release -y
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm -P /tmp
sudo rpm -ivh /tmp/mysql-community-release-el7-5.noarch.rpm
rm /tmp/mysql-community-release-el7-5.noarch.rpm

# Mysql server installieren und starten
sudo yum install -y mysql-server
sudo systemctl start mysqld

# Ufw installieren und einrichten
sudo yum install ufw -y
echo "y" | sudo ufw enable
sudo ufw allow from 10.0.2.2 to any port 22
echo "y" | sudo ufw delete 1    # Delete default allow any ssh
echo "y" | sudo ufw delete 3    # Delete default allow any sshv6
sudo ufw allow from $fe01 to any port 3306
sudo ufw reload

# Datenbankuser erstellen
sudo mysql -u root -e "CREATE USER 'seafile'@'$fe01';"

# Datenbanken erstellen
dbNames="seafiledb seahubdb ccnetdb"
for i in $dbNames; do
    sudo mysql -u root -e "CREATE DATABASE $i CHARACTER SET utf8 IF NOT EXISTS"
done

# Berechtigungen für seafile user definieren
for i in $dbNames; do
    sudo mysql -u root -e "GRANT ALL PRIVILEGES ON $i.* TO 'seafile'@'$fe01' IDENTIFIED BY '$DBPASSWORD' WITH GRANT OPTION;"
done

# Delete DB-Password file
sudo rm -rf /etc/profile.d/db-passwd.sh

echo "Database setup script complete!"