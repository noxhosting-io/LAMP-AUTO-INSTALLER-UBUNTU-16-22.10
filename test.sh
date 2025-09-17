#!/bin/bash

# Interactive installer script for Ubuntu 22.04
# Options: Apache2, PHP (7.4,8.1,8.3,8.4), MariaDB, phpMyAdmin, Composer,
# FFmpeg, LetsEncrypt, OpenVPN, TransmissionBT, Zip, Rar, Firewall rules

PHP_VERSIONS=(7.4 8.1 8.3 8.4)
SELECTED_PHP_VERSION=7.4

declare -A selections

options=("Apache2" "PHP" "MariaDB" "phpMyAdmin" "Composer" "FFmpeg" "LetsEncrypt" "OpenVPN" "TransmissionBT" "Zip" "Rar" "Add Firewall Rules" "Exit")

function print_menu() {
    echo "Select software to install by toggling options using the number keys."
    echo "Current PHP version selection: $SELECTED_PHP_VERSION"
    for i in "${!options[@]}"; do
        if [[ ${options[i]} == "PHP" ]]; then
            selected="[PHP $SELECTED_PHP_VERSION]"
        else
            selected="[${selections[${options[i]}]:- } ]"
        fi
        printf "%3d) %s %s\n" $((i+1)) "$selected" "${options[i]}"
    done
    echo "Enter a number to toggle/select, 'i' to install selected, or 'q' to quit."
}

function toggle_option() {
    local option="$1"
    if [[ "$option" == "PHP" ]]; then
        for i in "${!PHP_VERSIONS[@]}"; do
            if [[ "${PHP_VERSIONS[i]}" == "$SELECTED_PHP_VERSION" ]]; then
                next_index=$(( (i+1) % ${#PHP_VERSIONS[@]} ))
                SELECTED_PHP_VERSION="${PHP_VERSIONS[next_index]}"
                break
            fi
        done
    else
        if [[ ${selections[$option]} == "X" ]]; then
            selections[$option]=" "
        else
            selections[$option]="X"
        fi
    fi
}

function install_selected() {
    echo "Starting installation..."

    sudo apt update

    if [[ ${selections[Apache2]} == "X" ]]; then
        echo "Installing Apache2..."
        sudo apt install -y apache2
    fi

    # PHP installation via ondrej PPA for multiple PHP versions
    if [[ ${selections[PHP]} == "X" ]]; then
        echo "Adding PPA and installing PHP $SELECTED_PHP_VERSION and modules..."
        sudo apt install -y software-properties-common
        sudo add-apt-repository -y ppa:ondrej/php
        sudo apt update
        sudo apt install -y php${SELECTED_PHP_VERSION} php${SELECTED_PHP_VERSION}-cli php${SELECTED_PHP_VERSION}-common php${SELECTED_PHP_VERSION}-mysql php${SELECTED_PHP_VERSION}-curl php${SELECTED_PHP_VERSION}-mbstring php${SELECTED_PHP_VERSION}-xml php${SELECTED_PHP_VERSION}-zip
        sudo a2enmod php${SELECTED_PHP_VERSION}
        sudo systemctl restart apache2
    fi

    if [[ ${selections[MariaDB]} == "X" ]]; then
        echo "Installing MariaDB..."
        sudo apt install -y mariadb-server
        sudo systemctl enable mariadb
        sudo systemctl start mariadb
    fi

    if [[ ${selections[phpMyAdmin]} == "X" ]]; then
        echo "Installing phpMyAdmin..."
        sudo apt install -y phpmyadmin
        sudo phpenmod mysqli
        sudo systemctl restart apache2
    fi

    if [[ ${selections[Composer]} == "X" ]]; then
        echo "Installing Composer..."
        curl -sS https://getcomposer.org/installer | php
        sudo mv composer.phar /usr/local/bin/composer
    fi

    if [[ ${selections[FFmpeg]} == "X" ]]; then
        echo "Installing FFmpeg..."
        sudo apt install -y ffmpeg
    fi

    if [[ ${selections[LetsEncrypt]} == "X" ]]; then
        echo "Installing Certbot (Let’s Encrypt)..."
        sudo apt install -y certbot python3-certbot-apache
    fi

    if [[ ${selections[OpenVPN]} == "X" ]]; then
        echo "Installing OpenVPN..."
        sudo apt install -y openvpn easy-rsa
    fi

    if [[ ${selections[TransmissionBT]} == "X" ]]; then
        echo "Installing Transmission BitTorrent client..."
        sudo apt install -y transmission-cli transmission-common transmission-daemon
    fi

    if [[ ${selections[Zip]} == "X" ]]; then
        echo "Installing Zip and Unzip..."
        sudo apt install -y zip unzip
    fi

    if [[ ${selections[Rar]} == "X" ]]; then
        echo "Installing Rar and Unrar..."
        sudo apt install -y rar unrar
    fi

    if [[ ${selections["Add Firewall Rules"]} == "X" ]]; then
        echo "Adding firewall rules and enabling UFW..."
        sudo ufw allow 80/tcp
        sudo ufw allow 443/tcp
        sudo ufw allow 1194/udp
        sudo ufw allow 22/tcp
        sudo ufw enable
        echo "Firewall rules added."
    fi

    echo "Installation complete."
}

while true; do
    print_menu
    read -rp "Your choice: " choice
    case "$choice" in
        [1-9]|1[0-3])
            toggle_option "${options[$((choice-1))]}"
            ;;
        i|I)
            install_selected
            exit 0
            ;;
        q|Q)
            echo "Exiting without installation."
            exit 0
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
    echo
    sleep 1
done
