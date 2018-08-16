#! /bin/bash

# set_up_OpenStreetMap.sh
#
# Authors: Daming Li 	 (Massey ID: 15398736, Email: ldm2264@gmail.com, @Damming github.com)
#          Moravy Oum	 (Massey ID: , Email: , @ github.com)
#          Yaozu zhang	 (Massey ID: 15398302, Email: 1264453650@qq.com, @shadoade github.com)
#          Simon Freeman (Massey ID: , Email: , @ github.com)
#
# Create time: 01/Aug./2018
#
# License: 
#
# Description: Install all required libraries and turn a blanck Ubuntu Server to an OpenStreetMap Server
# 
# System required: Ubuntu Server 16.04


# Update Ubuntu & Install essential tools
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install ca-certificates curl unzip gdal-bin tar wget bzip2 build-essential clang

# Configure a swap (500M)
sudo fallocate -l 500M /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Set the en_GB locale
sudo locale-gen en_GB en_GB.UTF-8
sudo update-locale LANG='en_GB.UTF-8'
sudo update-locale LANGUAGE='en_GB.UTF-8'
sudo update-locale LC_ALL='en_GB.UTF-8'
. /etc/default/locale

# Install Git
sudo apt-get install -y git

sudo add-apt-repository -y ppa:no1wantdthisname/ppa
sudo apt-get update 
sudo apt-get install -y libfreetype6 libfreetype6-dev

# Install Mapnik from the standard Ubuntu repository
sudo apt-get install -y git autoconf libtool libxml2-dev libbz2-dev \
  libgeos-dev libgeos++-dev libproj-dev gdal-bin libgdal-dev g++ \
  libmapnik-dev mapnik-utils python-mapnik

# Install Apache HTTP Server
sudo apt-get install -y apache2 apache2-dev

# Install Mod_tile from source
sudo apt-get install -y autoconf autogen
mkdir -p ~/src
cd ~/src
git clone https://github.com/openstreetmap/mod_tile.git
cd mod_tile
./autogen.sh && ./configure && make && sudo make install && sudo make install-mod_tile && sudo ldconfig
cd ~/

# Install Yaml and Package Manager for Python
sudo apt-get install -y python-yaml
sudo apt-get install -y python-pip

# Install Mapnik Utilities
sudo apt-get install -y mapnik-utils

# Install openstreetmap-carto
cd ~/src
git clone https://github.com/gravitystorm/openstreetmap-carto.git
cd openstreetmap-carto

# Install the fonts needed by openstreetmap-carto
sudo apt-get install -y fonts-noto-cjk fonts-noto-hinted fonts-noto-unhinted fonts-hanazono ttf-unifont
cd ~/src
git clone https://github.com/googlei18n/noto-emoji.git
git clone https://github.com/googlei18n/noto-fonts.git
sudo cp noto-emoji/fonts/NotoColorEmoji.ttf /usr/share/fonts/truetype/noto
sudo cp noto-emoji/fonts/NotoEmoji-Regular.ttf /usr/share/fonts/truetype/noto
sudo cp noto-fonts/hinted/NotoSansArabicUI-Regular.ttf /usr/share/fonts/truetype/noto
sudo cp noto-fonts/hinted/NotoNaskhArabicUI-Regular.ttf /usr/share/fonts/truetype/noto
sudo cp noto-fonts/hinted/NotoSansArabicUI-Bold.ttf /usr/share/fonts/truetype/noto
sudo cp noto-fonts/hinted/NotoNaskhArabicUI-Bold.ttf /usr/share/fonts/truetype/noto
sudo cp noto-fonts/hinted/NotoSansAdlam-Regular.ttf /usr/share/fonts/truetype/noto
sudo cp noto-fonts/hinted/NotoSansAdlamUnjoined-Regular.ttf /usr/share/fonts/truetype/noto
sudo cp noto-fonts/hinted/NotoSansChakma-Regular.ttf /usr/share/fonts/truetype/noto
sudo cp noto-fonts/hinted/NotoSansOsage-Regular.ttf /usr/share/fonts/truetype/noto
sudo cp noto-fonts/hinted/NotoSansSinhalaUI-Regular.ttf /usr/share/fonts/truetype/noto
sudo cp noto-fonts/hinted/NotoSansArabicUI-Regular.ttf /usr/share/fonts/truetype/noto
sudo cp noto-fonts/hinted/NotoSansCherokee-Bold.ttf /usr/share/fonts/truetype/noto
sudo cp noto-fonts/hinted/NotoSansSinhalaUI-Bold.ttf /usr/share/fonts/truetype/noto
sudo cp noto-fonts/hinted/NotoSansSymbols-Bold.ttf /usr/share/fonts/truetype/noto
sudo cp noto-fonts/hinted/NotoSansArabicUI-Bold.ttf /usr/share/fonts/truetype/noto
sudo cp noto-fonts/unhinted/NotoSansSymbols2-Regular.ttf /usr/share/fonts/truetype/noto
sudo fc-cache -fv
sudo apt install fontconfig
fc-list
fc-list | grep Emoji

# Install old unifont Medium font (just removes the warning)
cd ~/src
mkdir OldUnifont
cd OldUnifont
wget http://http.debian.net/debian/pool/main/u/unifont/unifont_5.1.20080914.orig.tar.gz
tar xvfz unifont_5.1.20080914.orig.tar.gz unifont-5.1.20080914/font/precompiled/unifont.ttf
sudo cp unifont-5.1.20080914/font/precompiled/unifont.ttf /usr/share/fonts/truetype/unifont/OldUnifont.ttf
sudo fc-cache -fv
fc-list | grep -i unifont # both uppercase and lowercase fonts will be listed

#Create the data folder
cd ~/src
cd openstreetmap-carto
scripts/get-shapefiles.py

# installing Node.js v6.x
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && sudo apt-get install -y nodejs

#install the latest version 0 of carto
sudo npm install -g carto@0

#install mapnik-reference
npm install mapnik-reference

#Set the environment variables
export PGHOST=localhost
export PGPORT=5432
export PGUSER=postgres
export PGPASSWORD=postgres_007%

#Install PostgreSQL
sudo apt-get update
sudo apt-get install -y postgresql postgis pgadmin3 postgresql-contrib

# Set the password for the postgres user
echo 'localhost:5432:*:postgres:postgres_007%'>.pgpass
chmod 600 .pgpass
sudo sed -i 's|peer|trust|' /etc/postgresql/9.5/main/pg_hba.conf
sudo sed -i 's|md5|trust|' /etc/postgresql/9.5/main/pg_hba.conf
sudo service postgresql restart