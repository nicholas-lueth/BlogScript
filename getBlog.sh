#!/bin/bash
# Created by Nick Lueth, 12/4/2019.
# Special thanks to Young Chen for inspiration: https://www.linkedin.com/in/youngchen/
# Please do not copy this code and claim it to be your own. That would be excessively rude.

# Make a database user
echo "Database account creation:"
echo "(Please remember these for later when you log into your database.)"
echo "Username:"
read username
echo Password:
read password

# Stored database credentials
user=${username}
pass=${password}

# Replacing values in the wp-config.php file
sed -i "s/*USERNAME\*/$user/g" wp-config.php
sed -i "s/*PASSWORD\*/$pass/g" wp-config.php

# Installing wget
echo "Installing wget..."
yum install wget -y -q

# Installing httpd
echo "Installing HTTP..."
yum install httpd -y -q

# Enabling and starting httpd
echo "Starting HTTP..." 
systemctl enable httpd
systemctl start httpd

# Installing maria db
echo "Installing Maria DB..."
yum install mariadb-server mariadb -y -q

# Enabling and starting 
echo "Starting MariaDB..."
systemctl enable mariadb
systemctl start mariadb

# Installing mysql security features
echo "Securing MariaDB..."
mysql_secure_installation

# Installing some new repoitories and installing PHP
echo "Installing PHP..."
yum remove php -q
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y -q
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y -q
yum install yum-utils -y -q
yum-config-manager --enable remi-php70 -y -q
yum-config-manager --enable remi-php73 -y -q
yum install php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo -y -q

# Restarting httpd
echo "Restarting HTTP to load new configs..."
systemctl restart httpd

# Setting firewall rules
echo "Setting Firewall Rules..."
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https

# Reloading the firewall with the newly configured rules
echo "Reloading Firewall..."
firewall-cmd --reload

# Log in to MySQL
echo "Logging into MySQL..."
mysql -u root -p

# Installing php graphing library
echo "Obtaining WordPress..."
yum install php-gd -y -q

# Restarting httpd
systemctl restart httpd

# Get and install the latest wordpress package
wget http://wordpress.org/latest.tar.gz -q

# Unzip the wordpress package
echo "Unzipping Wordpress Install..."
tar xzvf latest.tar.gz

# Moving the wordpress files to /var/www/html/
echo "Moving Files..."
rsync -avP ~/scripts/BlogScript/wordpress/ /var/www/html/ -q

# Creating an uploads directory
echo "Making uploads directory..."
mkdir /var/www/html/wp-content/uploads

# Adjusting file pemissions in /var/www/html/
echo "Changing File Perms..."
chown -R apache:apache /var/www/html/*

# Copying config file over to the wordpress directory
echo "Sending config file..."
cp ~/scripts/BlogScript/wp-config.php /var/www/html/
