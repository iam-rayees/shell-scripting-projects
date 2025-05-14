#!/bin/bash

# Function to display helper message
function helper {
    echo "Usage: $0 <repo_owner> <repo_name>"
    echo "Example: $0 octocat Hello-World"
    exit 1
}

# Ensure correct number of arguments
if [ $# -ne 2 ]; then
    helper
fi

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token (must be set as environment variables)
USERNAME="${username}"
TOKEN="${token}"

# Check if credentials are set
if [[ -z "$USERNAME" || -z "$TOKEN" ]]; then
    echo "Error: GitHub username and token must be set as environment variables 'username' and 'token'."
    exit 1
fi

# User and Repository information
REPO_OWNER="$1"
REPO_NAME="$2"

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Main script execution
list_users_with_read_access
