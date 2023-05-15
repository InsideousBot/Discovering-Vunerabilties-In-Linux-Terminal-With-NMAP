#!/bin/bash

# Check if the script is running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root."
  exit
fi

# Update package lists and install necessary packages
echo "Updating packages and installing necessary tools..."
apt update && apt install -y nmap software-properties-common

# Install OpenVAS
echo "Adding OpenVAS repository and installing OpenVAS..."
add-apt-repository ppa:mrazavi/openvas -y
apt update
apt install -y openvas

# Configure and start OpenVAS
echo "Configuring and starting OpenVAS services..."
openvas-setup

# Get OpenVAS admin user credentials
echo "Getting OpenVAS admin user credentials..."
grep "password" /root/.gvmd/openvas-setup.log

# Perform a Nmap scan on the localhost
echo "Performing a Nmap scan on the localhost..."
nmap -sS -sU -T4 -A -v -oN nmap_scan_result.txt localhost

# OpenVAS scan commands
echo "To run an OpenVAS scan, use the following commands as an example:"
echo "--------------------------------------------------------------"
echo "1. Authenticate with OpenVAS:"
echo "   gvm-cli socket --xml \"<authenticate><credentials><username>admin</username><password>YOUR_PASSWORD</password></credentials></authenticate>\""
echo "2. Create a target:"
echo "   gvm-cli socket --xml \"<create_target><name>localhost</name><hosts>localhost</hosts></create_target>\""
echo "3. Create a task:"
echo "   gvm-cli socket --xml \"<create_task><name>Localhost Scan</name><config id='daba56c8-73ec-11df-a475-002264764cea'/><target id='YOUR_TARGET_UUID'/></create_task>\""
echo "4. Start the task:"
echo "   gvm-cli socket --xml \"<start_task task_id='YOUR
