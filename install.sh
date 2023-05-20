#!/bin/bash
###########################################################
# Script Auto Install Apache, PHP 7.4, MariaDB, phpmyadmin, FFMPEG, TRANSMISSION, OPENVPN, LETSENCRYPT
# Author     :  MAVEN
# Instagram  :  https://www.kalixhosting.com
# Version    :  1.1.0
# Date       :  05/20/2023
# OS         :  UBUNTU
###########################################################

echo "Auto Install LAMP Ubuntu"
echo "###########################"
echo "MADE BY MAVEN IG @maven_htx"
echo "© 2023 KalixHosting.com"

# Update packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Install nano and git
sudo apt-get install nano git -y

# Install Apache
sudo apt install -y apache2 apache2-utils
sudo systemctl start apache2
sudo systemctl enable apache2

# Configure Apache ports
sudo apt-get install iptables-persistent -y
declare -a ports=("80" "443" "22" "9091" "3389")
for port in "${ports[@]}"
do
    sudo iptables -I INPUT -p tcp --dport $port -j ACCEPT
done
sudo iptables-save | sudo tee /etc/iptables/rules.v4

# Set ownership and reload Apache
sudo chown www-data:www-data /var/www/html/ -R
sudo systemctl reload apache2

# Configure UFW
sudo apt-get install ufw -y
declare -a ufw_ports=("22" "80" "443" "21" "3389" "9091")
for port in "${ufw_ports[@]}"
do
    sudo ufw allow $port/tcp
done
sudo ufw enable

# Install MariaDB
sudo apt install mariadb-server mariadb-client -y
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo mysql_secure_installation

# Install PHP 7.4
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:ondrej/php -y
sudo apt install php7.4 -y
sudo apt install php libapache2-mod-php php7.4-mysql php7.4-bcmath php7.4-common php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-curl php7.4-gd php7.4-imagick php7.4-cli php7.4-dev php7.4-imap php7.4-mbstring php7.4-opcache php7.4-soap php7.4-zip php7.4-intl -y
sudo systemctl restart apache2
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php

# Install phpMyAdmin
sudo apt-get install phpmyadmin -y

# Install FFMPEG, RAR, zip, unzip
sudo apt-get install ffmpeg rar unrar zip unzip -y

# Install CURL and Composer
sudo apt-get install curl php-cli unzip -y
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
HASH=`curl -sS https://composer.github.io/installer.sig`
php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Verify Composer installation
composer

# Install yt-dlp
sudo wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp

# Install Transmission
sudo apt update && sudo apt upgrade -y
sudo apt-get install transmission-cli transmission-common transmission-daemon -y

echo "######## FIX MYSQL TO WORK WITH PHPMYADMIN AND ENTER INFO #########"

# Stop the MariaDB service
sudo systemctl stop mariadb

# Start MySQL in safe mode without grant tables and networking
sudo mysqld_safe --skip-grant-tables --skip-networking &

# Wait for MySQL to start
sleep 5

# Log in to MySQL
echo "##AFTER MYSQL IS LOGGED IN YOU WILL SEE THIS PROMPT (MariaDB [(none)]>)##"
echo "mysql -u root"

# Flush privileges
echo "##FIRST ENTER: FLUSH PRIVILEGES; ##"
echo "FLUSH PRIVILEGES;" | mysql -u root

# Set new password for root user
echo "##THEN ENTER: ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password'; TO SETUP PHPMYADMIN/MYSQL PASSWORD ##"
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'Z91*6tl8';" | mysql -u root

# Exit from MySQL
echo "##NEXT ENTER: exit ##"
echo "exit" | mysql -u root

# Restart the MariaDB service
echo "##RESTART SERVICE: sudo systemctl start mariadb ##"
sudo systemctl start mariadb

# Fix permissions for /var/www/html and /root directories
sudo chmod 777 /var/www/html/
sudo chmod +rwx /var/www/html/
sudo chmod 777 /root
sudo chmod +rwx /root

# Install OpenVPN
wget -4 https://git.io/vpn -O openvpn-install.sh && bash openvpn-install.sh

# Install Let's Encrypt
sudo apt install certbot python3-certbot-apache -y
sudo certbot --apache

# Completion message
echo "######## KALIXHOSTING AUTOINSTALL FOR UBUNTU 20 | FINISH #########"
