#!/usr/bin/env bash

# Directory containing the Git repositories
BASE_DIR="~/git_repos"

# Initialize counters
TOTAL_REPOS=0
UPDATED_REPOS=0

echo "Updating Git repositories in: $BASE_DIR"

# Iterate over all directories in BASE_DIR
for REPO_DIR in "$BASE_DIR"/*/; do
    if [ -d "$REPO_DIR/.git" ]; then
        ((TOTAL_REPOS++))
        echo "Processing repository: $(basename "$REPO_DIR")"
        
        # Perform git fetch and pull
        cd "$REPO_DIR" || exit
        git fetch && git pull && ((UPDATED_REPOS++))
        cd ..
    fi
done

echo -e "\nSummary:"
echo "Total repositories checked: $TOTAL_REPOS"
echo "Repositories successfully updated: $UPDATED_REPOS"

if [ $UPDATED_REPOS -lt $TOTAL_REPOS ]; then
    echo "Warning: Some repositories could not be updated."
fi