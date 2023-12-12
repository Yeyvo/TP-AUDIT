#!/bin/bash

# Copy scripts and files from the host to the guest

sudo su

cp -r ../TP-AUDIT/ ~/website/
chmod +x ~/website/kali/kali-provisioning.sh

cd ~/website/kali/
./kali-provisioning.sh

