#!/bin/bash

DB_NAME=wp
DB_USER=wp
DB_PASS=Unkn0wn107
WP_LOCL=en_US
WP_PATH=/var/www/html
WP_ADMN=agaley
WP_PASS=Unkn0wn107
WP_MAIL=agaley@student.42lyon.fr
USR_LOG=agaley

echo '*/10 * * * * root bash /root/status.sh' | sudo tee /etc/cron.d/status

sudo ufw allow http
sudo ufw allow 4242
sudo ufw enable

sudo apt install -y curl php php-fpm php-mysql php-curl php-xml php-json php-zip php-mbstring php-gd php-intl php-cgi 
echo "cgi.fix_pathinfo=1" | sudo tee -a /etc/php/7.4/fpm/php.ini
sudo systemctl restart php7.4-fpm

sudo lighttpd-enable-mod fastcgi
sudo lighttpd-enable-mod fastcgi-php-fpm
sudo ln -s /etc/lighttpd/conf-available/*fastcgi-php-fpm.conf /etc/lighttpd/conf-enabled/
sudo ln -s /etc/lighttpd/conf-available/*fastcgi.conf /etc/lighttpd/conf-enabled/
sudo systemctl restart lighttpd

# Setup db
sudo mysql -u root <<EOF
CREATE DATABASE $DB_NAME;
GRANT ALL PRIVILEGES on $DB_NAME.* TO $DB_USER@localhost IDENTIFIED BY $DB_PASS;
FLUSH PRIVILEGES;
EXIT;
EOF

# Install Wordpress
sudo curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x /usr/local/bin/wp
wp core download --path="$WP_PATH" --locale="$WP_LOCL"
wp config create --path="$WP_PATH" --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASS"
wp db create --path="$WP_PATH"
wp core install --path="$WP_PATH" --url=localhost --title="Born2BeRoot bonus Wordpress" \
  --admin_user="$WP_ADMN" --admin_password="$WP_PASS" --admin_email="$WP_MAIL"
sudo chown -R www-data:www-data /var/www/html

# Setup incremental backup script with rsync
sudo mkdir /srv/backups
sudo chown $USR_LOG:$USR_LOG /srv/backups
echo "0 1 * * * $USR_LOG bash /home/$USR_LOG/backup.sh" | sudo tee /etc/cron.d/
