#!/bin/bash
sudo apt-get update

sudo apt-get install netcat nmap -y

sudo apt-get install -y docker.io

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker


# Copy scripts and files from the host to the guest
cp -r /tmp/website/ ~/website/

cd ~/website/nginx

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout site_private.key -out site_certificate.crt -subj "/C=FR/ST=ISERE/L=GRENOBLE/O=HAKERMANS/OU=THeHakerMansUnit/CN=localhost"

cd ..

sudo docker-compose up -d

