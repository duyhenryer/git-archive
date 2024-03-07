#!/bin/bash

# Set up
TOKEN="your_pat_token"
ORG="your_organization_name"
REPO_FILE="repository_list.txt"

# Set up the API endpoint
URL="https://api.github.com/repos/$ORG"

# Archive each repository in the organization
while IFS= read -r REPO_NAME; do
  ARCHIVE_URL="$URL/$REPO_NAME"

  # Send the PATCH request to archive the repository
  RESPONSE=$(curl -sSL \
    -o /dev/null -w "%{http_code}" \
    -X PATCH \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token $TOKEN" \
    -H "Content-Type: application/json" \
    -d '{"archived": true}' \
    "$ARCHIVE_URL"
  )
  # Check the response status
  if [ "$RESPONSE" = "200" ]; then
    echo "Repository \"$REPO_NAME\" archived successfully!"
  elif [ "$RESPONSE" = "403" ]; then
    echo "Repository \"$REPO_NAME\" is already archived and read-only."
  else
    echo "Repository \"$REPO_NAME\" archive failed with status code: $RESPONSE"
  fi
done < "$REPO_FILE"

