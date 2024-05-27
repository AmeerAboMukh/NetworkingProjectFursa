#!/bin/bash

#check if the variable exists:
if [ -z "${KEY_PATH}" ]; then
    echo "KEY_PATH env var is expected"
    exit 5
fi

# Check if at least public instance is provided
if [ $# -lt 1 ]; then
    echo "Please provide bastion IP address"
    exit 5
fi

# Extract the arguments
PUBLIC_IP=$1
PRIVATE_IP=$2
COMMAND=$3

# Define the path to the new key file on the bastion host
NEW_KEY_PATH_PEM="/home/ubuntu/new_key_path.pem"

# Check if the new key file exists on the bastion host
ssh -i "$KEY_PATH" ubuntu@$PUBLIC_IP "test -f $NEW_KEY_PATH_PEM"
if [ $? -ne 0 ]; then
    echo "Failed to find the new key path file on the bastion host"
    exit 5
fi

# Choose one of the 3 cases to run :
# 1. Run a command in the private machine
# 2. Connect to the private instance from your local machine
# 3. Connect to the public instance
if [ -n "$PRIVATE_IP" ] && [ -n "$COMMAND" ]; then
        ssh -t -i "$KEY_PATH" ubuntu@"$PUBLIC_IP" "ssh -t -i $NEW_KEY_PATH_FILE ubuntu@$PRIVATE_IP '$COMMAND'"
elif [ -n "$PRIVATE_IP" ]; then
        ssh -t -i "$KEY_PATH" ubuntu@"$PUBLIC_IP" "ssh -t -i $NEW_KEY_PATH_PEM ubuntu@$PRIVATE_IP"
else
        ssh -t -i "$KEY_PATH" ubuntu@"$PUBLIC_IP"
fi