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

####################################################
# initialisation
####################################################

# Print usage
script_parameter_number=${#}
script_name=${0}
if [ $script_parameter_number -eq 0 ]; then
  echo -e "${script_name} APTITUDE_PASSWORD GIT_ACCOUNT GIT_PASSWORD"
  exit
fi

# 1st parameter: password for APTITUDE
root_password=${1}
check_parameter "ROOT_PASSWORD" $root_password

# 2nd parameter: password for GIT ACCOUNT
git_account=${2}
check_parameter "GIT_ACCOUNT" $git_account

# 3rd parameter: password for GIT PASSWORD
git_password=${3}
check_parameter "GIT_PASSWORD" $git_password


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
wget http://www.openfl.org/files/3313/8082/9421/haxe-3.0.1-linux-installer.tar.gz
# Installation of Haxe
tar -xvf haxe-3.0.1-linux-installer.tar.gz
echo "y" | ./install-haxe.sh
# Configuration of Haxe
haxe_lib_dir="/usr/lib/haxe"
echo "${root_password}" | sudo -S mkdir -p ${haxe_lib_dir}/lib
echo "${root_password}" | sudo -S chown -R $USER ${haxe_lib_dir}/
echo "${haxe_lib_dir}/lib" | haxelib setup

# Clean Haxe install
echo -e "\e[1;93mClean haxe install files.\e[0m"
rm -rf install-haxe.sh
rm -rf haxe-3.0.1-linux-installer.tar.gz

####################################################
# creation of DIRECTORY ARCHITECTURE
####################################################
echo -e "\e[1;93mDownload of BELUGA...\e[0m"
# Create architecture in the current directory
main_dir_name="test"
beluga_dir_name="beluga"
demo_dir_name="demo"
mkdir $main_dir_name
# Clone repositories in the $main_dir_name
pushd $main_dir_name
git_id="${git_account}:${git_password}"

git clone https://github.com/${git_account}/Beluga.git $beluga_dir_name
git clone https://github.com/${git_account}/BelugaDemo.git $demo_dir_name

####################################################
# installation of BELUGA PROJECT
####################################################
echo -e "\e[1;93mInstallation of BELUGA...\e[0m"
# Installation of the beluga library
pushd $beluga_dir_name
haxelib convertxml
zip -r beluga.zip beluga/ haxelib.json
haxelib local beluga.zip
popd
# Compilation of the demo project
pushd $demo_dir_name
haxe BelugaDemo.hxml
popd
