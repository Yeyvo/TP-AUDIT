#!/bin/bash

# Install Fail2Ban
sudo apt update
sudo apt install -y fail2ban

# Create a copy of the default Fail2Ban configuration file
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Edit the Fail2Ban configuration file
sudo tee /etc/fail2ban/jail.local > /dev/null <<EOL
[DEFAULT]
bantime = 3600
banaction = iptables-multiport

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
EOL

# Restart Fail2Ban
sudo service fail2ban restart
