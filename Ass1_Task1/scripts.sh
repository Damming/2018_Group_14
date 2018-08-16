#! /bin/bash

# set_up_OpenStreetMap.sh
#
# Authors: Daming Li 	 (Massey ID: 15398736, Email: ldm2264@gmail.com, @Damming github.com)
#          Moravy Oum	 (Massey ID: 16859528 , Email: moravy22@gmail.com , @Moravy github.com)
#          Yaozu zhang	 (Massey ID: , Email: , @ github.com)
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

#Create The PostGIS Instance

export PGPASSWORD=postgres_007%
HOSTNAME=localhost # set it to the actual ip address or host name
psql -U postgres -h $HOSTNAME -c "CREATE DATABASE gis ENCODING 'UTF-8' LC_COLLATE 'en_GB.utf8' LC_CTYPE 
'en_GB.utf8' TEMPLATE template0"

sudo sed -i '10i\ host all all 0.0.0.0/0 md5\' /etc/postgresql/9.5/main/pg_hba.conf
sudo /etc/init.d/postgresql restart

psql -U postgres -h $HOSTNAME -c "\connect gis"
psql -U postgres -h $HOSTNAME -d gis -c "CREATE EXTENSION postgis"
psql -U postgres -h $HOSTNAME -d gis -c "CREATE EXTENSION hstore"


psql -U postgres -c "create user tileserver;grant all privileges on database gis to tileserver;" 

echo shared_buffers = 128MB >> /etc/postgresql/9.5/main/postgresql.conf
echo min_wal_size = 80MB >> /etc/postgresql/9.5/main/postgresql.conf
echo max_wal_size = 1GB >> /etc/postgresql/9.5/main/postgresql.conf
echo work_mem = 4MB >> /etc/postgresql/9.5/main/postgresql.conf
echo maintenance_work_mem= 64MB>>/etc/postgresql/9.5/main/postgresql.conf
echo autovacuum = off>> /etc/postgresql/9.5/main/postgresql.conf
echo fsync = off>> /etc/postgresql/9.5/main/postgresql.conf
sudo /etc/init.d/postgresql stop
sudo /etc/init.d/postgresql start


cd ~/src/openstreetmap-carto
wget -c https://download.bbbike.org/osm/bbbike/Auckland/Auckland.osm.pbf

sudo sysctl -w vm.overcommit_memory=1
cd ~/src
cd openstreetmap-carto
HOSTNAME=localhost
osm2pgsql  -s  -C  300  -c  -G  --hstore  --style  openstreetmap-carto.style  --tag-transform-script 
openstreetmap-carto.lua -d gis -H $HOSTNAME -U postgres Auckland.osm.pbf

wget   https://raw.githubusercontent.com/openstreetmap/osm2pgsql/master/install-postgis-osm-user.sh
chmod a+x ./install-postgis-osm-user.sh
sudo ./install-postgis-osm-user.sh gis ubuntu


mapnik-config --input-plugins
sudo sed -i -e '/font_dir=/ s~=.*~= /usr/share/fonts~' /usr/local/etc/renderd.conf
sudo sed -i -e '/font_dir_recurse=/ s~=.*~= true~' /usr/local/etc/renderd.conf
sudo sed -i -e '/font_dir_recurse=/ s~=.*~= true~' /usr/local/etc/renderd.conf
sudo sed -i -e '/XML=/ s~=.*~= /home/ubuntu/src/openstreetmap-carto/style.xml~' /usr/local/etc/renderd.conf
sudo sed -i -e '/HOST=/ s~=.*~= localhost~' /usr/local/etc/renderd.conf

sudo cp ~/src/mod_tile/debian/renderd.init /etc/init.d/renderd
sudo chmod a+x /etc/init.d/renderd
sudo vi /etc/init.d/renderd

sudo sed -i -e 'DAEMON=/ s~=.*~= /usr/local/bin/$NAME~' /etc/init.d/renderd
sudo sed -i -e '/DAEMON_ARGS=/ s~=.*~= "-c /etc/renderd.conf"~' /etc/init.d/renderd
sudo sed -i -e '/RUNASUSER=/ s~=.*~=ubuntu~' /etc/init.d/renderd

sudo systemctl daemon-reload
sudo systemctl start renderd
sudo systemctl enable renderd

echo 'LoadModule tile_module /usr/lib/apache2/mod_tile.so' | sudo tee -a /etc/apache2/mods-available/mod_tile.load

sudo sed –i '4i\        LoadTileConfigFile /etc/renderd.conf\\' /etc/apache2/sites-enabled/000-default.conf
sudo sed –i '5i\        ModTileRenderdSocketName /var/run/renderd/renderd.sock\' /etc/apache2/sites-enabled/000-default.conf
sudo sed –i '6i\        ModTileRequestTimeout 3\' /etc/apache2/sites-enabled/000-default.conf
sudo sed –i '7i\        ModTileMissingRequestTimeout 60\' /etc/apache2/sites-enabled/000-default.conf
sudo sed –i '8i\        ServerAdmin webmaster@localhost\' /etc/apache2/sites-enabled/000-default.conf
sudo sed –i '9i\        DocumentRoot /var/www/html\' /etc/apache2/sites-enabled/000-default.conf
sudo sed –i '10i\       ErrorLog ${APACHE_LOG_DIR}/error.log \' /etc/apache2/sites-enabled/000-default.conf
sudo sed –i '11i\       CustomLog ${APACHE_LOG_DIR}/access.log combined \' /etc/apache2/sites-enabled/000-default.conf
sudo systemctl restart apache2


