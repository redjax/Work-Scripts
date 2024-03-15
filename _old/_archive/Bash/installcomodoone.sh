#!/bin/bash

# This script will download the enrollment file for Comodo One for Linux PCs, change the file
# to be executable, and run the installer.

COMODO_URL="https://<COMODO_SITE>.cmdm.comodo.com:443"

# Download the enrollment file.
cd ~/Downloads
wget $COMODO_URL/enroll/linux/run/token/b8bb66b5804db08036dba4cd283080ef
cd ~/Downloads

# Make the installer executable
chmod u+x itsm*installer.run

# Run installer
./itsm*installer.run
