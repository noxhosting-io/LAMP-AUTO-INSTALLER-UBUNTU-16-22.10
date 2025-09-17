#!/bin/bash
set -euo pipefail

# Ubuntu 22.04 LAMP/Plus Stack Installer with Interactive whiptail menu
# Replicates AlmaLinux functional structure, adapted for apt/ufw/environment

# Ensure whiptail is installed
if ! command -v whiptail &> /dev/null; then
    sudo apt update
    sudo apt install -y whiptail
fi

show_menu() {
    CHOICES=$(whiptail --title "Ubuntu LAMP+ Installer" --checklist \
    "Select components (Space toggles, Enter confirms):" 22 78 14 \
    "updates" "System update/upgrade" ON \
    "firewall" "Firewall (UFW) HTTP/HTTPS" ON \
    "apache" "Apache2 Web Server" ON \
    "php74" "PHP 7.4 (Ondrej PPA)" ON \
    "mariadb" "MariaDB server" ON \
    "securemdb" "Secure MariaDB (mysql_secure_installation)" ON \
    "phpmyadmin" "phpMyAdmin" ON \
    "certbot" "Certbot for Apache SSL" OFF \
    "transmission" "Transmission daemon" OFF \
    "btop" "btop" OFF \
    "perlcgi" "Perl CGI-related libraries" OFF \
    "ffmpeg" "FFmpeg" ON \
    "ytdlp" "yt-dlp" ON \
    3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
        echo "Aborted."
        exit 1
    fi
}

show_menu

# Helper to check if a choice was selected
has_choice() {
    [[ "$CHOICES" == *"$1"* ]]
}

# Summary display
SUMMARY="Components selected:"
for opt in updates firewall apache php74 mariadb securemdb phpmyadmin certbot transmission btop perlcgi ffmpeg ytdlp; do
    if has_choice "$opt"; then
        SUMMARY+=" $opt"
    fi
done

if ! whiptail --title "Confirm selection" --yesno "$SUMMARY" 20 70; then
    echo "Aborted."
    exit 1
fi

# Updates
if has_choice "updates"; then
    sudo apt update
    sudo apt upgrade -y
fi

# Firewall Setup (ufw)
if has_choice "firewall"; then
    sudo apt install -y ufw
    sudo ufw allow 'Apache Full'
    sudo ufw --force enable
    sudo ufw reload
fi

# Apache
if has_choice "apache"; then
    sudo apt install -y apache2
    sudo systemctl enable --now apache2
fi

# PHP 7.4 (via Ondrej PPA)
if has_choice "php74"; then
    sudo apt install -y software-properties-common
    sudo add-apt-repository -y ppa:ondrej/php
    sudo apt update
    sudo apt install -y php7.4 php7.4-cli php7.4-common php7.4-fpm php7.4-curl php7.4-gd php7.4-mbstring php7.4-xml php7.4-zip php7.4-mysql
    echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php >/dev/null
    sudo systemctl restart apache2
fi

# MariaDB
if has_choice "mariadb"; then
    sudo apt install -y mariadb-server
    sudo systemctl enable --now mariadb
    if has_choice "securemdb"; then
        sudo mysql_secure_installation
    fi
    sudo systemctl restart apache2
fi

# phpMyAdmin
if has_choice "phpmyadmin"; then
    sudo apt install -y phpmyadmin
    sudo ln -sf /usr/share/phpmyadmin /var/www/html/phpmyadmin
    sudo systemctl reload apache2
fi

# Certbot for Apache SSL
if has_choice "certbot"; then
    sudo apt install -y certbot python3-certbot-apache
    sudo a2enmod ssl
fi

# Transmission
if has_choice "transmission"; then
    sudo apt install -y transmission-daemon
    sudo systemctl enable --now transmission-daemon
fi

# btop
if has_choice "btop"; then
    sudo apt install -y btop
fi

# Perl CGI libs
if has_choice "perlcgi"; then
    sudo apt install -y perl libwww-perl libdbi-perl libdbd-mysql-perl libgd-perl libdigest-sha-perl liblwp-protocol-https-perl
fi

# FFmpeg
if has_choice "ffmpeg"; then
    sudo apt install -y ffmpeg
fi

# yt-dlp (standalone binary preferred)
if has_choice "ytdlp"; then
    sudo apt install -y python3-pip
    sudo pip3 install --upgrade yt-dlp
    sudo curl -fsSL https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
    sudo chmod a+rx /usr/local/bin/yt-dlp
fi

whiptail --title "Done" --msgbox "All selected components processed." 8 50
