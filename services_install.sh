#!/bin/bash

DB_NAME=wp
DB_USER=wp
DB_PASS=Unkn0wn107
WP_LOCL=en_US
WP_PATH=/var/www/html
WP_ADMN=agaley
WP_PASS=Unkn0wn107
WP_MAIL=agaley@student.42lyon.fr

sudo echo '*/10 * * * * root /bin/sh /root/status.sh' > /etc/cron.d/status
sudo apt install -y curl php php-fpm php-mysql php-curl php-xml php-json php-zip php-mbstring php-gd php-intl
sudo lighttpd-enable-mod fastcgi-php-fpm
sudo ln -s /etc/lighttpd/conf-available/*fastcgi-php-fpm.conf /etc/lighttpd/conf-enabled/

sudo mysql -u root <<EOF
CREATE DATABASE $DB_NAME;
GRANT ALL PRIVILEGES on $DB_NAME.* TO $DB_USER@localhost IDENTIFIED BY $DB_PASS;
FLUSH PRIVILEGES;
EXIT;
EOF

sudo curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x /usr/local/bin/wp
wp core download --path="$WP_PATH" --locale="$WP_LOCL"
wp config create --path="$WP_PATH" --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASS"
wp db create --path="$WP_PATH"
wp core install --path="$WP_PATH" --url=localhost --title="Born2BeRoot bonus Wordpress" \
  --admin_user="$WP_ADMN" --admin_password="$WP_PASS" --admin_email="$WP_MAIL"

echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect lighttpd" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-user string $DB_USER" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $DB_PASS" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $WP_PASS" |debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $WP_PASS" | debconf-set-selections

sudo apt -y install phpmyadmin
