#!/usr/bin/env bash

db_name="$1"
db_rootpassword="$2"
db_user="$3"
db_password="$4"

yum -y update

echo "[mariadb]" > /etc/yum.repos.d/MariaDB.repo
echo "name = MariaDB" >> /etc/yum.repos.d/MariaDB.repo
echo "baseurl = http://yum.mariadb.org/10.3/centos7-amd64/" >> /etc/yum.repos.d/MariaDB.repo
echo "gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB" >> /etc/yum.repos.d/MariaDB.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/MariaDB.repo

yum -y install httpd lynx
yum -y install MariaDB-server
yum -y erase mariadb-*
yum -y install MariaDB-server

systemctl start mariadb
systemctl enable mariadb

firewall-cmd --permanent --add-service=http
firewall-cmd --add-service=http

# Setup MySQL root password and create a user
mysqladmin -u root password $db_rootpassword
cat << EOF | mysql -u root --password=$db_rootpassword
CREATE DATABASE $db_name;
GRANT ALL PRIVILEGES ON $db_name.* TO $db_user@localhost IDENTIFIED BY '$db_password';
FLUSH PRIVILEGES;
EXIT
EOF

# Install Wordpress
yum -y install wget
yum install epel-release yum-utils –y
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum-config-manager --disable 'remi-php*'
sudo yum-config-manager --enable remi-php71
sudo yum-config-manager --enable remi-safe
sudo yum -y install php php-cli php-curl php-mcrypt php-opcache php-common php-mysql php-gd php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-snmp php-soap curl
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -zxvf latest.tar.gz -C /tmp/
cp -r /tmp/wordpress/* /var/www/html/
chown -R apache:apache /var/www/html/*
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

#sed -i "/Deny from All/d" /etc/httpd/conf.d/wordpress.conf
#sed -i "s/Require local/Require all granted/" /etc/httpd/conf.d/wordpress.conf
sed -i s/database_name_here/$db_name/ /var/www/html/wp-config.php
sed -i s/username_here/$db_user/ /var/www/html/wp-config.php
sed -i s/password_here/$db_password/ /var/www/html/wp-config.php
#sed -i s/localhost/$db_host/ /var/www/html/wp-config.php

systemctl restart httpd
systemctl enable httpd
systemctl restart sshd
