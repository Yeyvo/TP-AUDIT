#!/bin/bash
echo ""
echo "####################### START PROVISIONING #######################"
echo ""

echo ""
echo "####################### UPDATING PACKAGE LISTS #######################"
echo ""
sudo apt-get update

Upgrade all packages
echo ""
echo "####################### UPGRADE ALL PACKAGES (HARDENING) #######################"
echo ""
sudo apt-get upgrade -y

# # Kernel update (restart at the end)
# echo ""
# echo "####################### KERNEL UPDATE (HARDENING) #######################"
# echo ""
# sudo apt-get dist-upgrade -y

echo ""
echo "####################### INSTALLING NETCAT AND NMAP #######################"
echo ""
sudo apt-get install netcat nmap -y

echo ""
echo "####################### INSTALLING DOCKER #######################"
echo ""
sudo apt-get install -y docker.io

# Install Docker Compose
echo ""
echo "####################### INSTALLING DOCKER COMPOSE #######################"
echo ""
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Start and enable Docker service
echo ""
echo "####################### STARTING AND ENABLING DOCKER SERVICE #######################"
echo ""
sudo systemctl start docker
sudo systemctl enable docker


# echo ""
# echo "####################### CLEANUP (HARDENING) #######################"
# echo ""
# sudo apt-get autoremove -y
# sudo apt-get autoclean

# echo ""
# echo "####################### FULL (HARDENING) #######################"
# echo ""
# sudo DEBIAN_FRONTEND=noninteractive apt-get install selinux-basics selinux-policy-default auditd -y
# sudo selinux-activate



# # Copy scripts and files from the host to the guest
# echo ""
# echo "####################### COPYING WEBSITE FILES #######################"
# echo ""
# cp -r /tmp/hardening/ ~/hardening

# Copy scripts and files from the host to the guest
echo ""
echo "####################### COPYING WEBSITE FILES #######################"
echo ""
cp -r /tmp/website/ ~/website/

echo ""
echo "####################### CREATING SSL CERTIFICATE #######################"
echo ""
openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout ~/website/nginx/site_private.key -out ~/website/nginx/site_certificate.crt -subj "/C=FR/ST=ISERE/L=GRENOBLE/O=HAKERMANS/OU=THeHakerMansUnit/CN=localhost"



echo ""
echo "####################### BUILDING DOCKER CONTAINERS #######################"
echo ""
cd ~/website/
sudo docker-compose build --no-cache

echo ""
echo "####################### STARTING DOCKER CONTAINERS #######################"
echo ""
sudo docker-compose up -d 

echo ""
echo "####################### IP addresses of all interfaces #######################"
echo ""
ip -4 -brief address show


echo ""
echo "####################### END PROVISIONING #######################"

# echo ""
# echo "####################### REBOOT (HARDENING) #######################"
# echo ""
# reboot