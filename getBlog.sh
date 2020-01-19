#!/bin/bash
# Created by Nick Lueth, 12/4/2019.
# Special thanks to Young Chen for inspiration: https://www.linkedin.com/in/youngchen/

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
sed -i 's/*USERNAME*/$user/g' wp-config.php
sed -i 's/*PASSWORD*/$user/g' wp-config.php

# Installing wget
echo "Installing wget..."
yum install wget -yq

# Installing httpd
echo "Installing HTTP..."
yum install httpd -yq

# Enabling and starting httpd
echo "Starting HTTP..." 
systemctl enable httpd
systemctl start httpd

# Installing maria db
echo "Installing Maria DB..."
yum install mariadb-server mariadb -yq

# Enabling and starting 
echo "Starting MariaDB..."
systemctl enable mariadb
systemctl start mariadb

# Installing mysql security features
echo "Securing MariaDB..."
mysql_secure_installation

# Installing some new repoitories and installing PHP
echo "Installing PHP..."
yum remove php* -q
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -yq
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -yq
yum install yum-utils -yq
yum-config-manager --enable remi-php70 -yq
yum-config-manager --enable remi-php73 -yq
yum install php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo -yq

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
yum install php-gd -yq

# Restarting httpd
systemctl restart httpd

# Get and install the latest wordpress package
wget http://wordpress.org/latest.tar.gz -q

# Unzip the wordpress package
echo "Unzipping Wordpress Install..."
tar xzvf latest.tar.gz

# Moving the wordpress files to /var/www/html/
echo "Moving Files..."
rsync -avP ~/scripts/wordpress/ /var/www/html/

# Creating an uploads directory
echo "Making uploads directory..."
mkdir /var/www/html/wp-content/uploads

# Adjusting file pemissions in /var/www/html/
echo "Changing File Perms..."
chown -R apache:apache /var/www/html/*

# Copying config file over to the wordpress directory
echo "Sending config file..."
cp wp-config.php /var/www/html/
