#!/bin/bash

set -eou pipefail
IFS=$'\n\t'


# Description: Fetsh JSON data from an API and log important fields.
API_URL="https://jsonplaceholder.typicode.com/users"
OUTPUT="${WORKSPACE:-$(pwd)}/api_data.json"

echo "Fetching data from API.."
curl -s "$API_URL" -o "$OUTPUT"

echo "Data fetched successfully. Sample output:"
jq '.[] | {id, name, email}' "$OUTPUT" | head -5
