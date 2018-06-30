#!/usr/bin/env bash

SQLPW=vagrant

bigecho() {
    # fancy color cf https://misc.flogisoft.com/bash/tip_colors_and_formatting
    echo -e "\e[42m$1\e[0m"
}

# set xtrace variable and turn on xtrace (bigecho commands)
export PS4=$(echo -en "\e[32m")'+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'$(echo -en "\e[0m")
set -x

# we follow the sequence - thanks to
# https://www.howtoforge.com/ubuntu-lamp-server-with-apache2-php5-mysql-on-14.04-lts


bigecho "=== install mysql-server and mysql-client ==="
echo "MySql password will be set to $SQLPW"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $SQLPW"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $SQLPW"
apt-get -y install mysql-server mysql-client
mysql --version
mysqladmin --version
mysql -e "select user from mysql.user;" --password=$SQLPW


bigecho "=== install apache2 ==="
apt-get -y install apache2
cd /etc/apache2/
bash -c "echo ServerName localhost >>apache2.conf"
apache2ctl configtest
service apache2 restart
apache2 -v
cd ~
if ! [ -L /var/www ]; then
    rm -rf /var/www
    ln -fs /vagrant /var/www
fi
service apache2 restart


bigecho "=== install php5 ==="
apt-get -y install php5 libapache2-mod-php5
service apache2 restart
apt-get -y install php5-mysql php5-curl 
# php5.6-mcrypt php5.6-mbstring neded for phpmyadmin, maybe others
# php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl
# anything here needs be upgraded down below
service apache2 restart
php -v


# consider xcache for performance but maybe a bad idea for a dev box
# apt-get install php5-xcache

# consider phpmyadmin but it has to be made non-interactive install 
# apt-get install phpmyadmin


bigecho "=== upgrade from mysql 5.5. to mysql 5.6 ==="
apt-get -y update
apt-get -y upgrade
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $SQLPW"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $SQLPW"
apt-get -y install mysql-server-5.6 mysql-client-5.6 mysql-client-core-5.6
mysql --version
mysqladmin --version 
mysql -e "select user from mysql.user;" --password=$SQLPW


bigecho "=== upgrade php 5.5 to php 5.6 ==="
# for some reason can't get this to work using normal apt-get packages, so we use ondrej's PPA below
apt-get -y update
add-apt-repository -y ppa:ondrej/php
apt-get -y update
apt-get -y install php5.6 php5.6-mysql php5.6-curl # php5.6-cli # php5.6-gd php5.6-intl php5.6-xsl
a2dismod php5
a2enmod php5.6
service apache2 restart 
php -v

bigecho "=== enable apache2 .htaccess processing for things like server-side-includes (SSI) ==="
cd /etc/apache2/

FOO="
# enable .htaccess processing for things like server-side-includes (SSI)
<Directory /var/www/html>
        AllowOverride All
</Directory>
"
perl -i.backup -p0e 's@(<Directory /var/www/[\s\S]*?/Directory>\n)@$1'"$FOO"'@g' apache2.conf
diff apache2.conf.backup apache2.conf 

a2enmod include
service apache2 restart
cd ~

bigecho "=== provisioning complete ==="
