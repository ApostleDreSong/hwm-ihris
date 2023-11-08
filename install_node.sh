#!/bin/bash

# Update the package list to make sure you have the latest information
sudo apt update

# Install prerequisites
sudo apt-get install -y curl build-essential libssl-dev

# Install nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# Load nvm into the current shell session
source ~/.nvm/nvm.sh

# Install the LTS version of Node.js
nvm install '16.17.0'

# Use the LTS version as the default
nvm use '16.17.0'

# Install npm (which comes bundled with Node.js)
sudo apt-get install -y npm

# Install PM2 globally using npm
npm install -g pm2

npm install -g fsh-sushi
# npm install -g fsh-sushi@2.7.0

# Verify the installation
node -v
npm -v
pm2 -v
sushi -v

echo "Node.js, npm, and PM2 have been successfully installed."

# You can now use PM2 to manage your Node.js applications.
