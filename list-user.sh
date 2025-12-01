#!/bin/bash

# -------------------------
# Helper function to check arguments
# -------------------------
helper() {
    expected_cmd_args=2

    if [ $# -ne $expected_cmd_args ]; then
        echo "Please execute script properly, add cmd arguments"
        echo "Usage: $0 <REPO_OWNER> <REPO_NAME>"
        exit 1
    fi
}

# Call helper and pass script arguments
helper "$@"

# -------------------------
# GitHub API URL
# -------------------------
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=$username
TOKEN=$token

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

# -------------------------
# Function to make a GET request to GitHub API
# -------------------------
github_api_get() {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# -------------------------
# Function to list users with read access
# -------------------------
list_users_with_read_access() {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # Display results
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# -------------------------
# Main Script Execution
# -------------------------
echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
