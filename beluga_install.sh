#!/bin/bash

# Function which naively check the script parameters length.
# 1st parameter is parameter name. It's just a matter of printing
# 2nd parameter is parameter value.
check_parameter()
{
  parameter_name=$1
  parameter_value=$2
  parameter_length=$(expr length "$parameter_value")

  echo -n "$parameter_name: "
  if [ $parameter_length -eq 0 ]; then # Failure
    echo -e "\e[1;91mFAIL\e[0m"
    exit 
  else # Success
    echo -e "\e[1;92mOK\e[0m"
  fi
}

check_parameter_os_name()
{
  parameter_name=$1
  parameter_value=$2

  echo -n "$parameter_name: "
  if [ "$parameter_value" != "ubuntu" -a "$parameter_value" != "debian" ]; then # Failure
    echo -e "\e[1;91mFAIL\e[0m"
    exit 
  else # Success
    echo -e "\e[1;92mOK\e[0m"
  fi
}

####################################################
# initialisation
####################################################

# Print usage
script_parameter_number=${#}
script_name=${0}
if [ $script_parameter_number -eq 0 ]; then
  echo -e "${script_name} APTITUDE_PASSWORD GIT_ACCOUNT OS_NAME"
  exit
fi

# 1st parameter: password for APTITUDE
root_password=${1}
check_parameter "ROOT_PASSWORD" $root_password

# 2nd parameter: password for GIT ACCOUNT
git_account=${2}
check_parameter "GIT_ACCOUNT" $git_account

os_name=${3}
check_parameter "OS_NAME" $os_name
check_parameter_os_name "OS_NAME" $os_name

####################################################
# Check if a package is already installed
####################################################
# sudo:
# -S -> Read the password on STDIN
#
# apt-get:
# -y -> Assume Yes to all queries and do not prompt
check_package() {
    pkg_name=$1
    echo -e "\e[1;93mCheck for package $pkg_name\e[0m" 
    if dpkg-query -W $pkg_name; then
	echo -e "\e[1;92m$pkg_name is already installed on your system\e[0m"
    else
	echo -e "\e[1;91mCan\'t find $pkg_name on your system.\e[0m"
	echo -e "\e[1;93mTry to install $pkg_name\e[0m"
	echo "${root_password}" | sudo -S apt-get install $pkg_name -y
    fi
}

if [ "$parameter_value" == "debian" ]; then
    echo "deb http://ftp.debian.org/debian sid main" >> /etc/apt/sources.list
    apt-get update
    apt-get -t -y sid install libc6 libc6-dev libc6-dbg
fi

####################################################
# installation of ZIP
####################################################
check_package zip

####################################################
# installation of GIT
####################################################
check_package git

echo -e "\e[1;93mCheck if LAMP is already installed on your system.\e[0m" 
####################################################
# installation of APACHE
####################################################
check_package apache2

####################################################
# installation of PHP
####################################################
check_package php5

####################################################
# installation of 
####################################################
check_package mysql-server

####################################################
# Lamp utilities
####################################################
check_package libapache2-mod-php5
check_package php5-mysql

####################################################
# installation of HAXE
####################################################
echo -e "\e[1;93mInstallation of HAXE...\e[0m"
# Download Haxe
wget http://www.openfl.org/builds/haxe/haxe-3.1.3-linux-installer.tar.gz
# Installation of Haxe
tar -xvf haxe-3.1.3-linux-installer.tar.gz
echo "y" | ./install-haxe.sh
# Configuration of Haxe
haxe_lib_dir="/usr/lib/haxe"
echo "${root_password}" | sudo -S mkdir -p ${haxe_lib_dir}/lib
echo "${root_password}" | sudo -S chown -R $USER ${haxe_lib_dir}/
echo "${haxe_lib_dir}/lib" | haxelib setup

# Clean Haxe install
echo -e "\e[1;93mClean haxe install files.\e[0m"
rm -rf install-haxe.sh
rm -rf hhaxe-3.1.3-linux-installer.tar.gz

####################################################
# creation of DIRECTORY ARCHITECTURE
####################################################
echo -e "\e[1;93mDownload of BELUGA...\e[0m"
# Create architecture in the current directory
main_path="$PWD/test"

beluga_path="$main_path/beluga"
beluga_test_path="$beluga_path/test"
beluga_www_path="$beluga_path/test/bin/php"

demo_path="$main_path/dominax"
demo_www_path="$demo_path/bin/php"

mkdir $main_path
# Clone repositories in the $main_path
pushd $main_path
git clone https://github.com/${git_account}/Beluga.git $beluga_path
git clone https://github.com/${git_account}/Dominax.git $demo_path

####################################################
# installation of BELUGA PROJECT
####################################################
echo -e "\e[1;93mInstallation of BELUGA...\e[0m"
pushd $beluga_path
haxelib dev beluga .
haxelib install session
haxelib install tink_macro
popd

pushd $beluga_test_path
wget --output-document=config/database.xml "https://raw.github.com/brissa-a/BelugaDevUtils/master/"$os_name"_database.xml" 
haxe BelugaTest.hxml
    pushd $beluga_www_path
    wget https://raw.github.com/brissa-a/BelugaDevUtils/master/.htaccess
    popd
popd

pushd $demo_path
wget --output-document=config/database.xml "https://raw.github.com/brissa-a/BelugaDevUtils/master/"$os_name"_database.xml" 
haxe dominax.hxml
    pushd $demo_www_path
    wget https://raw.github.com/brissa-a/BelugaDevUtils/master/.htaccess
    popd
popd

echo -e "\e[1;93mConfiguring web server\e[0m" 
####################################################
# installation of APACHE
####################################################

apacheconf="/etc/apache2/sites-available/default"

#Add hosts
# $1 listening port
# $2 documentroot
echo_virtual_host () {
    echo "Listen $1"
    echo "NameVirtualHost *:$1"
    echo "<VirtualHost *:$1>"
    echo "    DocumentRoot $2"
    echo "</VirtualHost>"
}

echo_virtual_host "81" "$beluga_www_path" >> $apacheconf
echo_virtual_host "82" "$demo_www_path" >> $apacheconf

#Check rewrite mod enabled
a2enmod rewrite
apachectl restart

chown www-data -R $main_path

echo -e "\e[1;93mConfiguring database\e[0m" 
####################################################
# Configuration MYSQL
####################################################
if [ "$parameter_value" == "debian" ]; then
mysql -p$root_password << EOF
CREATE DATABASE belugaDemo;
EOF
fi
