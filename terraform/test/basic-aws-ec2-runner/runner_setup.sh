#!/bin/bash

# Create a folder owned by ubuntu
cd /home/ubuntu
mkdir -p actions-runner
chown ubuntu:ubuntu actions-runner
cd actions-runner

# Download the runner package
curl -o actions-runner-linux-x64-2.333.1.tar.gz -L \
  https://github.com/actions/runner/releases/download/v2.333.1/actions-runner-linux-x64-2.333.1.tar.gz

# Extract as ubuntu
sudo -u ubuntu -i tar -xzf /home/ubuntu/actions-runner/actions-runner-linux-x64-2.333.1.tar.gz -C /home/ubuntu/actions-runner

# Configure the runner as ubuntu (non-interactive)
sudo -u ubuntu -i /home/ubuntu/actions-runner/config.sh \
  --url https://github.com/DiaDeMuertos/runners-inside-aws-vpc \
  --token AABJVPBBZ5B7T4VDLY5X7BTJ4FAUO \
  --name ec2-runner-01 \
  --runnergroup Default \
  --labels linux,aws,test \
  --work _work \
  --replace

# Start the runner as ubuntu
# sudo -u ubuntu -i /home/ubuntu/actions-runner/run.sh

# Install the GitHub Actions runner as a systemd service and start it
sudo ./svc.sh install
sudo ./svc.sh start

###
# NOTES
# <-- gh command line to get a token -->
# gh api -X POST repos/DiaDeMuertos/runners-inside-aws-vpc/actions/runners/registration-token
###

