#!/bin/bash

# Copy scripts and files from the host to the guest

sudo su

cp -r ../TP-AUDIT/ ~/website/
chmod +x ~/website/pop-test-vm/kali/kali-provisioning.sh

cd ~/website/pop-test-vm/kali/
./kali-provisioning.sh

