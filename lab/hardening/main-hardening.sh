#!/bin/bash

sudo su

echo "#########################################################"
echo "#### Creating a backup policy and automatic schedule ####"
echo "#########################################################"

./backup-config.sh

echo "#########################################################"
echo "###### Configuring IPTable allowlist and blocklist ######"
echo "#########################################################"

./iptable-config.sh

echo "#########################################################"
echo "##### Configuring fail2ban tool with log monitoring #####"
echo "#########################################################"

./fail2ban-config.sh
