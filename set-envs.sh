#!/bin/bash

# List of secrets to check for
secrets=(
    "TEST_VAR" 
    "test-secret2" 
    "test-secret1"
    )

# Run gcloud command and list secret names
output=$(gcloud secrets list)

# Check each secret in the list
for secret in "${secrets[@]}"; do
    # Use grep to search for the secret name in the output
    if echo "$output" | grep -q "$secret"; then
        # Secret is already present, update version
        echo "updating $secret version..."
        echo -n "${{ secrets["$secret"] }}" | gcloud secrets versions add $secret \
                --replication-policy="automatic" \
                --data-file=-
    else
        # Secret does not exist, create first version
        echo "creating $secret..."
        echo -n "${{ secrets["$secret"] }}" | gcloud secrets create $secret \
                --replication-policy="automatic" \
                --data-file=-
    fi
done