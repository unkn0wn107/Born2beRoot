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

echo $'\nSetup ufw'
sudo ufw allow 80
sudo ufw allow 4242
sudo ufw --force enable

echo $'\nInstall php'
sudo apt install -y curl php php-fpm php-mysql php-curl php-xml php-json php-zip php-mbstring php-gd php-intl
echo "cgi.fix_pathinfo=1" | sudo tee -a /etc/php/7.4/fpm/php.ini
sudo systemctl restart php7.4-fpm

echo $'Configure Lighttpd'
sudo sed -i $'s/^.*fpm\.sock.*$/\t"socket" => "/var/run/php/php7.4-fpm.sock",/' /etc/lighttpd/conf-available/*php-fpm.conf
sudo lighttpd-enable-mod accesslog
sudo lighttpd-enable-mod rewrite
sudo lighttpd-enable-mod fastcgi
sudo lighttpd-enable-mod fastcgi-php-fpm
sudo systemctl restart lighttpd

# Setup db
echo $'\nConfigure database'
sudo mysql -u root <<EOF
CREATE DATABASE $DB_NAME;
GRANT ALL on $DB_NAME.* TO '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
FLUSH PRIVILEGES;
EOF

# Install Wordpress
echo $'\nInstall Wordpress'
sudo curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x /usr/local/bin/wp
wp core download --path="$WP_PATH" --locale="$WP_LOCL"
wp config create --path="$WP_PATH" --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASS"
wp db create --path="$WP_PATH"
wp core install --path="$WP_PATH" --url=localhost --title="Born2BeRoot bonus Wordpress" \
  --admin_user="$WP_ADMN" --admin_password="$WP_PASS" --admin_email="$WP_MAIL"
sudo chown -R www-data:www-data /var/www/html

# Setup incremental backup script with rsync
echo $'\nInstall incremental backup service'
sudo mkdir /srv/backups
sudo chown $USR_LOG:$USR_LOG /srv/backups
echo "0 1 * * * $USR_LOG bash /home/$USR_LOG/backup.sh" | sudo tee /etc/cron.d/backup

cat <<EOF

Installation of Wordpress on Lighttpd + php-fpm complete

If everything went well :
- Access Wordpress on http://localhost
- http://localhost/wp-admin default logs : agaley pass : Unkn0wn107
- Backups are done incrementally every day at 1am in /srv/backups

EOF

