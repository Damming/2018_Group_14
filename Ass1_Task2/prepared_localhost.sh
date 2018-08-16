#!/bin/bash

# prepared_localhost.sh
#
# Author: Daming Li 14/Aug./2018
#
# IMPORTANT: Change aws_access_key_id and aws_secret_access_key before run this script!!!
#
# Description: This Shell Script will install Ansible and Boto in the current system. Then,
#              a Ansible playbook used to create a new AWS KeyPair will be created.
#              The new KeyPair is ~/.ssh/keypairForAnsible.yem.

# ---------- install ansible & boto ----------
# Upload Ubuntu source packages
sudo apt update
sudo apt upgrade -y
sudo apt install software-properties-common

# Add ppa:ansible/ansible to system’s Software Source
sudo apt-add-repository ppa:ansible/ansible -y

# Update repository and install ansible
sudo apt update
sudo apt install ansible -y
sudo apt install python-pip -y

# Install boto
pip install botocore boto boto3

# ---------- configure boto ----------
# Setup AWS credentials/API keys
mkdir -pv ~/.aws/
echo "[default]
aws_access_key_id = AKIAITCS7W62BJRQI2VQ
aws_secret_access_key = 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" > ~/.aws/credentials

# Setup default AWS region:
echo "[default]
region = us-east-2" > ~/.aws/config

# Create hosts file
echo -e "[local]
localhost \n
[webserver]" > ~/hosts