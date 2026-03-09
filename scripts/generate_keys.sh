#!/bin/bash

HOSTNAME=$1

# Replace <HOSTNAME> placeholder in the script
HOSTNAME_VALUE="$HOSTNAME"

# Create a temporary directory with the correct permissions
install -d -m755 "./tmp/persist/etc/ssh"

# Generate the desired SSH keys in the created directory
ssh-keygen -q -t ed25519 -f "./tmp/persist/etc/ssh/ssh_host_ed25519_key" -N "" -C "$HOSTNAME_VALUE"
ssh-keygen -q -t rsa -b 4096 -f "./tmp/persist/etc/ssh/ssh_host_rsa_key" -N "" -C "$HOSTNAME_VALUE"

# Ensure that the SSH keys have the appropriate permissions
chmod 600 ./tmp/persist/etc/ssh/*

# Create target directory for public keys
install -d -m755 "./hosts/$HOSTNAME_VALUE"

# Copy public keys to ./hosts/<HOSTNAME>
cp ./tmp/persist/etc/ssh/*.pub "./hosts/$HOSTNAME_VALUE/"

echo "SSH keys generated and copied to ./hosts/$HOSTNAME_VALUE/"
