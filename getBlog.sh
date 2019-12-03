#!/bin/bash
echo "Making a DB account. Please remember these for later when dealing with logging in to DB"
echo "Username:"
read username
echo Password:
read password
user=${username}
pass=${password}
sed -i 's/*USERNAME*/$user/g' wp-config.php
sed -i 's/*PASSWORD*/$user/g' wp-config.php

echo "Installing WGET..."
yum -y install wget

echo "Installing HTTP..."
yum -y install httpd

echo "Starting HTTP..." 
systemctl enable httpd
systemctl start httpd

echo "Installing Maria DB..."
yum -y install mariadb-server mariadb

echo "Starting MariaDB..."
systemctl enable mariadb
systemctl start mariadb

echo "Securing MariaDB..."
mysql_secure_installation

echo "Installing PHP..."
yum remove php*
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
yum install yum-utils -y
yum-config-manager --enable remi-php70 -y
yum-config-manager --enable remi-php73 -y
yum install php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo -y

echo "Restarting HTTP to load new configs..."
systemctl restart httpd

echo "Setting Firewall Rules..."
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https

echo "Reloading Firewall..."
firewall-cmd --reload

echo "Logging into MySQL..."
mysql -u root -p

echo "Obtaining WordPress"
yum -y install php-gd
systemctl restart httpd
cd ~
wget http://wordpress.org/latest.tar.gz

echo "Unzipping Wordpress Install"
tar xzvf latest.tar.gz

echo "Moving Files"
rsync -avP ~/wordpress/ /var/www/html/

echo "Making uploads directory"
mkdir /var/www/html/wp-content/uploads

echo "Changing File Perms"
chown -R apache:apache /var/www/html/*

echo "Making config file"
cp wp-config.php /var/www/html/
