# Update Ubuntu & Install essential tools
ansible all -s -m shell -a 'apt-get update' 

# sudo apt-get -y upgrade
ansible all -s -m shell -a 'apt-get install ca-certificates curl unzip gdal-bin tar wget bzip2 build-essential clang' 

# Install Git
ansible all -s -m shell -a 'apt-get install git' 

# Update Freetype6
ansible all -s -m shell -a 'add-apt-repository ppa:no1wantdthisname/ppa' 
ansible all -s -m shell -a 'apt-get update'
ansible all -s -m shell -a 'apt-get install libfreetype6 libfreetype6-dev'

# Install Mapnik from the standard Ubuntu repository
# sudo add-apt-repository -y ppa:talaj/osm-mapnik
# sudo apt-get update
ansible all -s -m shell -a 'apt-get install git autoconf libtool libxml2-dev libbz2-dev' 
ansible all -s -m shell -a 'libgeos-dev libgeos++-dev libproj-dev gdal-bin libgdal-dev g++' 
ansible all -s -m shell -a 'libmapnik-dev mapnik-utils python-mapnik'

# Install Apache HTTP Server
ansible all -s -m shell -a 'apt-get install apache2 apache2-dev'

# Install Yaml and Package Manager for Python
ansible all -s -m shell -a 'apt-get install python-yaml'
ansible all -s -m shell -a 'apt-get install python-pip'

# Install Mapnik Utilities
ansible all -s -m shell -a 'apt-get install mapnik-utils'

#Install PostgreSQL
ansible all -s -m shell -a 'apt-get update' 
ansible all -s -m shell -a 'apt-get install -y postgresql postgis pgadmin3 postgresql-contrib'  



