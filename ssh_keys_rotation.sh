#!/bin/bash

# Ensure the script is executed with a private instance IP
if [ $# -ne 1 ]; then
    echo "Usage: $0 <private-instance-ip>"
    exit 1
fi

PRIVATE_IP=$1
KEY_PATH="/home/ubuntu/ameerKey.pem"

# Generate a new key pair
NEW_KEY_PATH="/home/ubuntu/new_key"

ssh-keygen -t rsa -b 4096 -f $NEW_KEY_PATH -N "" -C "key_rotation"

# Append the new public key to authorized_keys on the private instance
cat $NEW_KEY_PATH.pub | ssh -i "$KEY_PATH" ubuntu@$PRIVATE_IP "cat > ~/.ssh/authorized_keys"

# Replace the old key with the new key in the KEY_PATH & setting the permissions for new key
sudo mv $NEW_KEY_PATH $KEY_PATH
sudo rm $NEW_KEY_PATH.pub
sudo chmod 400 $KEY_PATH