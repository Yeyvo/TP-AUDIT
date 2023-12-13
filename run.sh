#!/bin/bash

# Copy scripts and files from the host to the guest

sudo su

cp -r ../TP-AUDIT/lab/website ~/website/

sudo chmod +x ./pop-test-vm/kali/kali-provisioning.sh

cd ./pop-test-vm/kali/
./kali-provisioning.sh

