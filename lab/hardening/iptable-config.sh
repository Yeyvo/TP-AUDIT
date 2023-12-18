#!/bin/bash

# Flush existing rules and set the default policies to DROP
iptables -F
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Allow incoming SSH 
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow incoming HTTP
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# Allow incoming HTTPS
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Allow loopback interface
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow established and related connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Log and drop other incoming connections
iptables -A INPUT -j LOG --log-prefix "iptables: " --log-level 7
iptables -A INPUT -j DROP

# Save the rules to persist across reboots
touch /etc/iptables/rules.v4
iptables-save > /etc/iptables/rules.v4