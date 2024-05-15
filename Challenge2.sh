#!/bin/bash
# Retrieve instance ID
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

# Retrieve instance metadata using AWS CLI
INSTANCE_METADATA=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --region your_aws_region)

# Extract relevant metadata
INSTANCE_NAME=$(echo $INSTANCE_METADATA | jq -r '.Reservations[0].Instances[0].Tags[] | select(.Key=="Name") | .Value')
INSTANCE_ENV=$(echo $INSTANCE_METADATA | jq -r '.Reservations[0].Instances[0].Tags[] | select(.Key=="Environment") | .Value')
PUBLIC_IP=$(echo $INSTANCE_METADATA | jq -r '.Reservations[0].Instances[0].PublicIpAddress')
PRIVATE_IP=$(echo $INSTANCE_METADATA | jq -r '.Reservations[0].Instances[0].PrivateIpAddress')
SUBNET_ID=$(echo $INSTANCE_METADATA | jq -r '.Reservations[0].Instances[0].SubnetId')
REGION=$(echo $INSTANCE_METADATA | jq -r '.Reservations[0].Instances[0].Placement.Region')

# Format metadata as JSON
echo "{\"instance_id\": \"$INSTANCE_ID\", \"instance_name\": \"$INSTANCE_NAME\", \"instance_env\": \"$INSTANCE_ENV\", \"PUBLIC_IP\": \"$PUBLIC_IP\", \"PRIVATE_IP\": \"$PRIVATE_IP\", \"SUBNET_ID\": \"$SUBNET_ID\", \"REGION\": \"$REGION\"}"


