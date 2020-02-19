#!/bin/bash

#
# This file is called from Kickstart to
# finalize the container installation
#

set -e

sudo apt-get update && sudo apt-get -y install lsb-release gnupg2 docker.io pwgen ccrypt



## Install Azure (manual update)
#
# Azure will install by default to /opt and won't be told to not do so.
# So we have to do the by user install running
#
# curl -L https://aka.ms/InstallAzureCli | bash
#
# and then
#
# tar -czf /opt/azure-cli.tar.gz /home/user/lib
#
# Copy it to /flavor

sudo apt-get install -y libssl-dev libffi-dev python3-dev build-essential

tar -xzf /kickstart/flavor/azure-cli.tar.gz -C /
sudo ln -s /home/user/lib/azure-cli/bin/az /usr/bin/az



# Create environment variable for correct distribution
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"

# Add the Cloud SDK distribution URI as a package source
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list


#curl -sL https://packages.microsoft.com/keys/microsoft.asc |
#    gpg --dearmor |
#    sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null

#AZ_REPO=$(lsb_release -cs)
##echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
#    sudo tee /etc/apt/sources.list.d/azure-cli.list

# Import the Google Cloud Platform public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Update the package list and install the Cloud SDK

cd /srv
sudo apt-get update && sudo apt-get -y install google-cloud-sdk npm



base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
  sudo mv /tmp/docker-machine /usr/local/bin/docker-machine &&
  chmod +x /usr/local/bin/docker-machine


## Install Terraform

curl -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip
sudo unzip /tmp/terraform.zip -d /usr/bin
rm /tmp/terraform.zip



