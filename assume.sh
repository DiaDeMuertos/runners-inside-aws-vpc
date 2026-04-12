#!/bin/bash

ASSUME_ROLE=false

if [[ "$1" == "assume" ]];then
    aws sts assume-role --role-arn arn:aws:iam::583664563303:role/OrganizationAccountAccessRole --role-session-name test > credentials.json

    export AWS_ACCESS_KEY_ID=$(jq -r '.Credentials.AccessKeyId' credentials.json)
    export AWS_SECRET_ACCESS_KEY=$(jq -r '.Credentials.SecretAccessKey' credentials.json)
    export AWS_SESSION_TOKEN=$(jq -r '.Credentials.SessionToken' credentials.json)

    ASSUME_ROLE=true
    echo "Assumen role successful, credentials set in environments variables."
fi

# list aws resources for testing
aws s3 ls

echo "Current list of users accounts:"
aws iam list-users

# clean up

rm -rf credentials.json

for (( i; i< count; i++ )); do
done

