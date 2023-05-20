#!/bin/bash
###########################################################
#Script Auto Install Apache, PHP 7.4, MariaDB, phpmyadmin,FFMPEG,TRANSMISSION,OPENVPN,LETSENCRYPT
#Author		:  MAVEN
#Instagram	:  https://www.kalixhosting.com
#Version	:  1.1.0
#Date		:  05/20/2023
#OS		:  UBUNTU
###########################################################

echo "Auto Install LAMP Ubuntu"
echo "###########################"
echo "MADE BY MAVEN IG @maven_htx"
echo "© 2023 KalixHosting.com"

#UPDATE

sudo apt-get update -y

sudo apt-get upgrade -y

#nano
apt-get install nano -y

#git
apt-get install git -y

#APACHE
sudo apt install -y apache2 apache2-utils
sudo systemctl start apache2
sudo systemctl enable apache2
#PORTS
sudo apt-get install iptables-persistent -y
sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 9091 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 3389 -j ACCEPT
sudo iptables-save | sudo tee /etc/iptables/rules.v4
#CHMODVARANDREBOOT
sudo chown www-data:www-data /var/www/html/ -R
sudo systemctl reload apache2

#PORTSUFW
apt-get install ufw -y

sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 21/tcp
sudo ufw allow 3389/tcp
sudo ufw allow 9091/tcp

sudo ufw enable


#MARIADB
sudo apt install mariadb-server mariadb-client -y
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo mysql_secure_installation



#PHP7.4
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:ondrej/php -y
sudo apt install php7.4 -y
sudo apt install php libapache2-mod-php php7.4-mysql php7.4-bcmath php7.4-common php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-curl php7.4-gd php7.4-imagick php7.4-cli php7.4-dev php7.4-imap php7.4-mbstring php7.4-opcache php7.4-soap php7.4-zip php7.4-intl -y 
sudo systemctl restart apache2
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php

#PHPMYADMIN
sudo apt-get install phpmyadmin -y

#FFMPEG
sudo apt-get install ffmpeg -y

#RAR
sudo apt-get install rar -y
sudo apt-get install unrar -y

#zip
sudo apt-get install zip -y
sudo apt-get install unzip -y


#CURL
sudo apt-get install curl -y

#COMPRESOR
sudo apt install php-cli unzip -y
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
HASH=`curl -sS https://composer.github.io/installer.sig`
php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

#VERIFY Compressor

composer

#YTDLP
sudo wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp

#transmission
sudo apt update && sudo apt upgrade -y
sudo apt-get install transmission-cli transmission-common transmission-daemon -y 




#FIX MYSQL/PHPMYADMIN
echo "######## FIX MYSQL TO WORK WITH PHPMYADMIN AND ENTER INFO #########"
#FIX MYSQL/PHPMYADMIN
sudo systemctl stop mariadb
#FIX MYSQL/PHPMYADMIN
echo "##AFTER MYSQL IS LOGGED IN U SEE THIS PROMPT (MariaDB [(none)]>)#"

sudo mysqld_safe --skip-grant-tables --skip-networking &

echo mysql -u root
#FIX MYSQL/PHPMYADMIN
echo "##FIRST ENTER: FLUSH PRIVILEGES; ##"
echo FLUSH PRIVILEGES;
#FIX MYSQL/PHPMYADMIN
echo "##THEN ENTER: ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password'; TO SETUP PHPMYADMIN/MYSQL PASSWORD ##"

echo ALTER USER 'root'@'localhost' IDENTIFIED BY 'Z91*6tl8';
#FIX MYSQL/PHPMYADMIN
echo "##NEXT ENTER: exit ##"
echo exit
#FIX MYSQL/PHPMYADMIN
echo "##RESTART SERVICES:sudo systemctl start mariadb ##"
sudo systemctl start mariadb

#FIXPERMISSION IF NOT ROOT FOR /ROOT & /VAR/WWW/HTML
chmod 777 /var/www/html/
chmod +rwx /var/www/html/
chmod 777 /root
chmod +rwx /root

#OPENVPN
wget -4 https://git.io/vpn -O openvpn-install.sh && bash openvpn-install.sh


#LETEncrypt
sudo apt install certbot python3-certbot-apache -y
sudo certbot --apache

#COMPLETED
echo "######## KALIXHOSTING AUTOINSTALL FOR UBUNTU 20 | FINISH #########"
