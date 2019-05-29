#!/bin/bash

# Updates herunterladen
# sudo yum update -y

# Wget herunterladen
sudo yum install wget -y

# Benötigte Repositories herunterladen und installieren
sudo yum install epel-release -y
sudo rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro && sudo rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
sudo yum install python-imaging MySQL-python python-distribute python-memcached python-ldap python-urllib3 ffmpeg ffmpeg-devel python-requests pwgen -y

# Ufw installieren und einrichten
sudo yum install ufw -y
echo "y" | sudo ufw enable
sudo ufw allow from 10.0.2.2 to any port 22
echo "y" | sudo ufw delete 1    # Delete default allow any ssh
echo "y" | sudo ufw delete 3    # Delete default allow any sshv6
sudo ufw allow from 10.0.2.2 to any port 80
sudo ufw allow from 10.0.2.2 to any port 443
sudo ufw reload
sudo setsebool -P httpd_can_network_connect 1

# SSL Self Signed Zertifikat erstellen
sudo mkdir /root/ssl
echo "Zertifikate erstellen ..."
sudo openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -subj "/C=CH/ST=Zurich/L=Zurich/O=IT/CN=$serverName" -keyout /etc/ssl/certs/privkey.key  -out /etc/ssl/certs/cert.crt &> /dev/null
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048 &> /dev/null

# Nginx installieren und konfigurieren
sudo yum install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
sudo cat > /etc/nginx/nginx.conf << EOL
events {
    worker_connections  1024;
}

http {    
    server {
        listen       80;
        server_name  $fe01;
        rewrite ^ https://\$http_host\$request_uri? permanent;
        server_tokens off;
    }
    server {
        listen 443 ssl http2;
        server_name $fe01;
        
        ssl on;
        ssl_certificate /etc/ssl/certs/cert.crt;
        ssl_certificate_key /etc/ssl/certs/privkey.key;
        ssl_session_timeout 5m;
        ssl_session_cache shared:SSL:5m;

        ssl_dhparam /etc/ssl/certs/dhparam.pem;

        #SSL Security
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256';
        ssl_ecdh_curve secp384r1;
        ssl_prefer_server_ciphers on;
        server_tokens off;
        ssl_session_tickets off;

        proxy_set_header X-Forwarded-For \$remote_addr;

        location / {
            proxy_pass         http://127.0.0.1:8000;
            proxy_set_header   Host \$host;
            proxy_set_header   X-Real-IP \$remote_addr;
            proxy_set_header   X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header   X-Forwarded-Host \$server_name;
            proxy_read_timeout  1200s;

            # used for view/edit office file via Office Online Server
            client_max_body_size 0;

            access_log      /var/log/nginx/seahub.access.log;
            error_log       /var/log/nginx/seahub.error.log;
        }

        location /seafhttp {
            rewrite ^/seafhttp(.*)$ \$1 break;
            proxy_pass http://127.0.0.1:8082;
            client_max_body_size 0;
            proxy_set_header   X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_connect_timeout  36000s;
            proxy_read_timeout  36000s;
            proxy_send_timeout  36000s;
            send_timeout  36000s;
        }
        location /media {
            root /home/vagrant/seafile-server-latest/seahub;
        }
    }
}
EOL
sudo systemctl restart nginx

# Download seafile
wget https://download.seadrive.org/seafile-server_7.0.0_x86-64.tar.gz -P /tmp &> /dev/null
tar -xzvf /tmp/seafile-server_7.0.0_x86-64.tar.gz -C /home/vagrant/ &> /dev/null
/home/vagrant/seafile-server-7.0.0/setup-seafile-mysql.sh auto -n $serverName -i $fe01 -p 8082 -d /home/vagrant/seafile-data/ -e 1 -o $db01 -t 3306 -u seafile -w $dbPassword -c ccnetdb -s seafiledb -b seahubdb
rm /tmp/seafile-server_7.0.0_x86-64.tar.gz
sudo chown -R vagrant:vagrant /home/vagrant/

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
cp /home/vagrant/seafile-server-latest/check_init_admin.py  /home/vagrant/seafile-server-latest/check_init_admin.py.bkp
seafileAdminPw=$(pwgen)
eval "sed -i 's/= ask_admin_email()/= \"${seafileAdmin}\"/' /home/vagrant/seafile-server-latest/check_init_admin.py"
eval "sed -i 's/= ask_admin_password()/= \"${seafileAdminPw}\"/' /home/vagrant/seafile-server-latest/check_init_admin.py"
sudo  -u vagrant /home/vagrant/seafile-server-latest/seafile.sh start
sudo  -u vagrant /home/vagrant/seafile-server-latest/seahub.sh start
sudo  -u vagrant /home/vagrant/seafile-server-latest/seafile.sh stop
sudo  -u vagrant /home/vagrant/seafile-server-latest/seahub.sh stop
mv /home/vagrant/seafile-server-latest/check_init_admin.py.bkp /home/vagrant/seafile-server-latest/check_init_admin.py

# Seafile config

# Seafile und seahub service erstellen
sudo cat > /etc/systemd/system/seafile.service << EOL
[Unit]
Description=Seafile
After=network.target mysql.service

[Service]
Type=forking
ExecStart=/home/vagrant/seafile-server-latest/seafile.sh start
ExecStop=/home/vagrant/seafile-server-latest/seafile.sh stop
User=vagrant
Group=vagrant

[Install]
WantedBy=multi-user.target
EOL

sudo cat > /etc/systemd/system/seahub.service << EOL
[Unit]
Description=Seafile hub
After=network.target seafile.service

[Service]
Type=forking
ExecStart=/home/vagrant/seafile-server-latest/seahub.sh start
ExecStop=/home/vagrant/seafile-server-latest/seahub.sh stop
User=vagrant
Group=vagrant

[Install]
WantedBy=multi-user.target
EOL

# Daemon neustarten, services starten und enablen
sudo systemctl daemon-reload
sudo systemctl start seafile
sleep 2
sudo systemctl start seahub
sleep 1
sudo systemctl enable seafile
sudo systemctl enable seahub

# DB-Password file löschen
sudo rm -rf /etc/profile.d/passwd.sh
unset seafileAdminPw

echo "Frontend setup script complete!"
echo "Seafile Admin User password: $seafileAdminPw"