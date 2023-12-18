#!/bin/bash

sudo su


echo "#########################################################"
echo "#### Creating a backup policy and automatic schedule ####"
echo "#########################################################"

mkdir /backups/

echo -e "#!/bin/bash\n\n\
SOURCE_DIR=\"~/\"\n\
DEST_DIR=\"/backups/\"\n\
TIMESTAMP=\$(date +%Y%m%d%H%M%S)\n\n\
rsync -a --delete \$SOURCE_DIR \$DEST_DIR/backup_\$TIMESTAMP\n\
tar czf \$DEST_DIR/snapshot_\$TIMESTAMP.tar.gz -C \$DEST_DIR backup_\$TIMESTAMP\n\
find \$DEST_DIR -type d -name \"backup_*\" -mtime +3 -exec rm -r {} \;" > backup_script.sh

chmod +x backup_script.sh

# Schedule backup_script.sh to run daily
echo "0 0 * * * /path/to/backup_script.sh" | crontab -

echo "#########################################################"
echo "###### Configuring IPTable allowlist and blocklist ######"
echo "#########################################################"

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
iptables-save > /etc/iptables/rules.v4
