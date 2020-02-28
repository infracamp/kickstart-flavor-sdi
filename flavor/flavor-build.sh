#!/bin/bash

#
# This file is called from Kickstart to
# finalize the container installation
#

set -e

sudo apt-get update && sudo apt-get -y install lsb-release gnupg2 docker.io pwgen ccrypt jq awscli iputils-ping dnsutils



## Install Azure (manual update)
#
# see BUILD_README.md on how to update

sudo apt-get install -y libssl-dev libffi-dev python3-dev build-essential

tar -xzf /kickstart/flavor/azure-cli.tar.gz -C /
sudo ln -s /usr/azure-cli/az /usr/bin/az
sudo chown -R root:root /usr/azure-cli
sudo chmod -R 755 /usr/azure-cli


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
sudo apt-get update && sudo apt-get -y install google-cloud-sdk npm kubectl



base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
  sudo mv /tmp/docker-machine /usr/local/bin/docker-machine &&
  chmod +x /usr/local/bin/docker-machine


## Install Terraform

curl -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip
sudo unzip /tmp/terraform.zip -d /usr/bin
rm /tmp/terraform.zip


kubectl completion bash > /etc/bash_completion.d/kubectl
sudo -u user terraform -install-autocomplete
