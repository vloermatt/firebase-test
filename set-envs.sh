#!/bin/bash

# List of secrets to check for
env_list=(
    "TEST_VAR" 
    )

# Run gcloud command and list secret names
output=$(gcloud secrets list)

# Check each secret in the list
for secret in "${env_list[@]}"; do
    # Use grep to search for the secret name in the output
    if echo "$output" | grep -q "$secret"; then
        # Secret is already present, update version
        echo "updating $secret version..."
        echo -n "$$secret" | gcloud secrets versions add $secret \
                --data-file=-
    else
        # Secret does not exist, create first version
        echo "creating $secret..."
        echo -n "${{ secrets[$secret] }}" | gcloud secrets create $secret \
                --replication-policy="automatic" \
                --data-file=-
    fi
done