#!/bin/bash
echo "################################################################################"
echo "####################### START PROVISIONING #######################"
echo "################################################################################"

echo "################################################################################"
echo "####################### UPDATING PACKAGE LISTS #######################"
echo "################################################################################"
sudo apt-get update

Upgrade all packages
echo "################################################################################"
echo "####################### UPGRADE ALL PACKAGES (HARDENING) #######################"
echo "################################################################################"
# sudo apt-get upgrade -y

# # Kernel update (restart at the end)
# echo "################################################################################"
# echo "####################### KERNEL UPDATE (HARDENING) #######################"
# echo "################################################################################"
# sudo apt-get dist-upgrade -y

# echo "################################################################################"
# echo "####################### INSTALLING NETCAT AND NMAP #######################"
# echo "################################################################################"
# sudo apt-get install netcat nmap -y

echo "################################################################################"
echo "####################### INSTALLING DOCKER #######################"
echo "################################################################################"
sudo apt-get install -y docker.io

# Install Docker Compose
echo "################################################################################"
echo "####################### INSTALLING DOCKER COMPOSE #######################"
echo "################################################################################"
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Start and enable Docker service
echo "################################################################################"
echo "####################### STARTING AND ENABLING DOCKER SERVICE #######################"
echo "################################################################################"
sudo systemctl start docker
sudo systemctl enable docker


# echo "################################################################################"
# echo "####################### CLEANUP (HARDENING) #######################"
# echo "################################################################################"
# sudo apt-get autoremove -y
# sudo apt-get autoclean

# echo "################################################################################"
# echo "####################### FULL (HARDENING) #######################"
# echo "################################################################################"
# sudo DEBIAN_FRONTEND=noninteractive apt-get install selinux-basics selinux-policy-default auditd -y
# sudo selinux-activate



# # Copy scripts and files from the host to the guest
# echo "################################################################################"
# echo "####################### COPYING WEBSITE FILES #######################"
# echo "################################################################################"
# cp -r /tmp/hardening/ ~/hardening

# Copy scripts and files from the host to the guest
echo "################################################################################"
echo "####################### COPYING WEBSITE FILES #######################"
echo "################################################################################"
cp -r /tmp/website/ ~/website/

echo "################################################################################"
echo "####################### CREATING SSL CERTIFICATE #######################"
echo "################################################################################"
openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout ~/website/nginx/site_private.key -out ~/website/nginx/site_certificate.crt -subj "/C=FR/ST=ISERE/L=GRENOBLE/O=HAKERMANS/OU=THeHakerMansUnit/CN=localhost"

echo "################################################################################"
echo "####################### MODSECURITY DEPENDENCIES  #######################"
echo "################################################################################"
cd ~/website/
# Directory where ModSecurity configurations will be stored
MODSEC_DIR="./modsecurity-config"
# Clone the OWASP CRS repository
# git clone https://github.com/coreruleset/coreruleset.git /tmp/coreruleset
wget https://github.com/coreruleset/coreruleset/archive/refs/tags/v3.3.5.tar.gz -O /tmp/v3.3.5.tar.gz
tar xzvf /tmp/v3.3.5.tar.gz -C /tmp/
# mv -r /tmp/coreruleset-3.3.5/* /tmp/coreruleset
# Create a directory for the rules
mkdir -p $MODSEC_DIR/rules
# Copy the relevant files
cp /tmp/coreruleset-3.3.5/crs-setup.conf.example $MODSEC_DIR/crs-setup.conf
cp -r /tmp/coreruleset-3.3.5/rules/ $MODSEC_DIR/

# Clean up the temporary directory
# rm -rf /tmp/coreruleset

# Copy the ModSecurity base configuration file (modsecurity.conf)
# This file might be sourced from a different location or created manually.
# For this example, it's assumed to be available in the current directory
cp ./modsecurity.conf $MODSEC_DIR/
cd $MODSEC_DIR
wget https://raw.githubusercontent.com/SpiderLabs/ModSecurity/v3/master/unicode.mapping -O unicode.mapping
wget https://raw.githubusercontent.com/SpiderLabs/ModSecurity/v3/master/modsecurity.conf-recommended -O modsecurity.conf



echo "################################################################################"
echo "####################### BUILDING DOCKER CONTAINERS #######################"
echo "################################################################################"
sudo docker-compose build --no-cache

echo "################################################################################"
echo "####################### STARTING DOCKER CONTAINERS #######################"
echo "################################################################################"
sudo docker-compose up -d 

echo "################################################################################"
echo "####################### IP addresses of all interfaces #######################"
echo "################################################################################"
ip -4 -brief address show


echo ""
echo "####################### Hardening the setup #######################"
echo ""
cd /tmp/hardening/
sed -i -e 's/\r$//' main-hardening.sh backup-config.sh fail2ban-config.sh iptable-config.sh 
chmod +x main-hardening.sh backup-config.sh fail2ban-config.sh iptable-config.sh 
./main-hardening.sh



echo "################################################################################"
echo "####################### END PROVISIONING #######################"
setxkbmap fr
# echo "################################################################################"
# echo "####################### REBOOT (HARDENING) #######################"
# echo "################################################################################"
# reboot