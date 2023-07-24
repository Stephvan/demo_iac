#!/bin/bash

# Replace the following variables with your actual Git repo details and GitHub PAT
GIT_REPO_1_URL="https://github.com/Stephvan/lifebitdemo.gits"
GIT_REPO_2_URL="https://github.com/Stephvan/lifebit-source-code.git"
FOLDER_1="repo_1_folder"
FOLDER_2="repo_2_folder"
PARENT_FOLDER="CICD-Demo"
GIT_BRANCH="dev"
GITHUB_PAT="YOUR_GITHUB_PAT_HERE"

# Function to clone Git repo and checkout the specified branch
clone_and_checkout() {
  local repo_url=$1
  local folder=$2

  echo "Cloning the Git repository: $repo_url..."
  git clone $repo_url $folder
  if [ $? -ne 0 ]; then
    echo "Error: Failed to clone Git repository: $repo_url. Are you using the right credential or the right Gihub URL"
    exit 1
  fi

  cd $folder
  git checkout $GIT_BRANCH
  if [ $? -ne 0 ]; then
    echo "Error: Failed to switch to the '$GIT_BRANCH' branch in Git repository: $repo_url"
    exit 1
  fi
  echo "Git repository cloned and switched to the '$GIT_BRANCH' branch."
  cd ..
}

# Create a parent directory to store the cloned repositories
mkdir -p $PARENT_FOLDER
cd $PARENT_FOLDER

# Clone the first Git repo with authentication
export GIT_ASKPASS="/usr/bin/echo"
export GIT_USERNAME="your_username"
export GIT_PASSWORD="$GITHUB_PAT"
export GIT_TERMINAL_PROMPT=1
clone_and_checkout $GIT_REPO_1_URL $FOLDER_1

# Clone the second Git repo with authentication
export GIT_ASKPASS="/usr/bin/echo"
export GIT_USERNAME="your_username"
export GIT_PASSWORD="$GITHUB_PAT"
export GIT_TERMINAL_PROMPT=1
clone_and_checkout $GIT_REPO_2_URL $FOLDER_2

# Add a line to go into the Terraform folder and run the run_terraform.sh script
cd $FOLDER_1/Infra/Terraform
chmod +x run_terraform.sh
./run_terraform.sh
if [ $? -ne 0 ]; then
  echo "Error: Failed to execute the Terraform script."
  exit 1
fi

echo "Both Git repositories cloned and checked out on the '$GIT_BRANCH' branch. Terraform script executed successfully."