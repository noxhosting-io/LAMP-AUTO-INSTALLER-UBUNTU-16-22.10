
![Logo](https://kalixhosting.com/img/logo.svg)


# UBUNTU LAMP AUTO INSTALL

UBUNTU 16.04 - 22.10 LAMP AUTO INSTALLER SCRIPT


## Authors

- [@maven_htx](https://instagram.com/maven_htx)


## Features

- APACHE2
- PHP 7.4
- MARIADB
- PHPMYADMIN
- COMPOSER
- FFMPEG
- PHPMYADMIN
- LETS ENCRYPT
- OPENVPN
- TRANSMISSIONBT (TORRENT DOWNLOADER)
- ZIP
- RAR 
- FIREWALL RULES ADDED






## Installation

Install Script

```bash
 wget -4 https://scripts.kalixhosting.com/ubuntu/lampfullstacks/ -O install.sh && bash install.sh

```
    
## REMEMBER TO CHANGE MYSQL/PHPMYADMIN PASSWORD
RUN THESE COMMANDS

DEFAULT Password is Z91*6tl8

Change Password to your Desired Password where you see NEWPASS


```bash
sudo systemctl stop mariadb
sudo mysqld_safe --skip-grant-tables --skip-networking & mysql -u

PASTE THIS INSIDE MYSQL PROMPT 

root ALTER USER 'root'@'localhost' IDENTIFIED BY 'NEWPASS';"
NOW TYPE

exit

NOW RUN 

sudo systemctl start mariadb
```
VERIFY BY checking http://locoalhost/phpmyadmin and test login



## WANT TO SET UP VIRUAL HOST RUN THESE COMMANDS 

Replace kalixhosting.com with your Desired Domain


```bash
sudo mkdir -p /var/www/kalixhosting.com/public_html



sudo chown -R www-data: /var/www/kalixhosting.com

sudo chown -R www-data: /var/www/kalixhosting.com

nano /etc/apache2/sites-available/kalixhosting.com.conf

INSIDE OF NANO PASTE THESE BELOW 

<VirtualHost *:80>
    ServerName kalixhosting.com
    ServerAlias www.kalixhosting.com
    ServerAdmin webmaster@kalixhosting.com
    DocumentRoot /var/www/kalixhosting.com/public_html

    <Directory /var/www/kalixhosting.com/public_html>
        Options -Indexes +FollowSymLinks
        AllowOverride All
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/kalixhosting.com-error.log
    CustomLog ${APACHE_LOG_DIR}/kalixhosting.com-access.log combined
</VirtualHost>

CONTROL X   Y SAVE 

NOW RUN 

sudo a2ensite kalixhosting.com

THEN RESTART APACHE2

sudo systemctl restart apache2


```

## ADD LETS ENCRYPT SSL TO VirtualHost

RUN THIS COMMAND

```bash
sudo certbot --apache

```





## 🔗 Links
KALIXHOSTING https://kalixhosting.com/
