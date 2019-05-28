#!/bin/bash

# Updates herunterladen
sudo yum update -y

# Wget herunterladen
sudo yum install -y wget

# Benötigte Repositories herunterladen und installieren
sudo yum install epel-release -y

# Ufw installieren und einrichten
sudo yum install ufw -y
echo "y" | sudo ufw enable
sudo ufw allow from 10.0.2.2 to any port 22
echo "y" | sudo ufw delete 1    # Delete default allow any ssh
echo "y" | sudo ufw delete 3    # Delete default allow any sshv6
sudo ufw reload

# Delete DB-Password file
sudo rm -rf /etc/profile.d/db-passwd.sh

echo "Frontend setup script complete!"