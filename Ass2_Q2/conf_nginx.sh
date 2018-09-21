#! /bin/bash

sudo apt-get update
sudo apt-get -y install nginx

sudo vi /etc/nginx/nginx.conf

# ----------------------------------------
# put the following lines in http section

upstream mysite {
    server 54.186.216.105:8081;
    server 54.186.216.105:8082;
    server 54.186.216.105:8083 backup;
}

server {
    listen 80;
    server_name nginx_ip;
    location / {
        root html;
        index index.html;
        proxy_pass http://mysite;
    }
}

# ----------------------------------------

cd /usr/sbin/
sudo ./nginx -s reload