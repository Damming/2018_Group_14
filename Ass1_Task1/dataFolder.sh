#!/bin/bash
#program:Set up a data folder and install some packages. 
echo "Authors: Yaozu Zhang"


#Create the data folder
cd ~/src
cd openstreetmap-carto
scripts/get-shapefiles.py

# installing Node.js v6.x
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && sudo apt-get install -y nodejs
node -v
nodejs -v
npm -v

#install the latest version 0 of carto
sudo npm install -g carto@0
carto -v

#install mapnik-reference
npm install mapnik-reference
#list all the known API versions 
node -e "console.log(require('mapnik-reference'))"

#Test carto and produce style.xml from the openstreetmap-carto style
cd ~/src
cd openstreetmap-carto
carto -a "3.0.6" project.mml > style.xml

#Set the environment variables
export PGHOST=localhost
export PGPORT=5432
export PGUSER=postgres
export PGPASSWORD=postgres_007%

#Install PostgreSQL
sudo apt-get update
sudo apt-get install -y postgresql postgis pgadmin3 postgresql-contrib

#start the db
sudo service postgresql start