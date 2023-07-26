#!/bin/bash

SSH_KEY_FILE=~/.ssh/id_rsa
SSH_PUBLIC_KEY_FILE=~/.ssh/id_rsa.pub

# Check if the SSH key pair already exists
if [ -f "$SSH_KEY_FILE" ] && [ -f "$SSH_PUBLIC_KEY_FILE" ]; then
  echo "SSH key pair already exists. Skipping key generation."
else
  # Generate SSH key pair
  echo "Generating SSH key pair..."
  ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_FILE" -N ""
fi

# Replace the following variables with your actual Git repo details and GitHub PAT
GIT_REPO_1_URL="https://github.com/Stephvan/lifebitdemo.git"
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

# Function to check if a directory is empty
is_directory_empty() {
  local dir=$1
  if [ -z "$(ls -A $dir)" ]; then
    return 0 # Empty
  else
    return 1 # Not empty
  fi
}

# Create a parent directory to store the cloned repositories
mkdir -p $PARENT_FOLDER
cd $PARENT_FOLDER

# Check if the folder already exists and contains files
if is_directory_empty $FOLDER_1; then
  echo "The directory $FOLDER_1 is empty. Cloning the Git repository..."
  clone_and_checkout $GIT_REPO_1_URL $FOLDER_1
else
  echo "The directory $FOLDER_1 is not empty. Fetching the difference..."
  cd $FOLDER_1
  git fetch origin $GIT_BRANCH
  if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch the difference in Git repository: $GIT_REPO_1_URL"
    exit 1
  fi
  git checkout $GIT_BRANCH
  if [ $? -ne 0 ]; then
    echo "Error: Failed to switch to the '$GIT_BRANCH' branch in Git repository: $GIT_REPO_1_URL"
    exit 1
  fi
  cd ..
fi

# Check if the folder already exists and contains files
if is_directory_empty $FOLDER_2; then
  echo "The directory $FOLDER_2 is empty. Cloning the Git repository..."
  clone_and_checkout $GIT_REPO_2_URL $FOLDER_2
else
  echo "The directory $FOLDER_2 is not empty. Fetching the difference..."
  cd $FOLDER_2
  git fetch origin $GIT_BRANCH
  if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch the difference in Git repository: $GIT_REPO_2_URL"
    exit 1
  fi
  git checkout $GIT_BRANCH
  if [ $? -ne 0 ]; then
    echo "Error: Failed to switch to the '$GIT_BRANCH' branch in Git repository: $GIT_REPO_2_URL"
    exit 1
  fi
  cd ..
fi

# ... (other parts of the script)

# Add a line to go into the Terraform folder and run the run_terraform.sh script
cd $FOLDER_1/Infra/Terraform
chmod +x run_terraform.sh
./run_terraform.sh
if [ $? -ne 0 ]; then
  echo "Error: Failed to execute the Terraform script."
  exit 1
fi

echo "Both Git repositories cloned and checked out on the '$GIT_BRANCH' branch. Terraform script executed successfully."


# # Replace the following variables with your actual Git repo details and GitHub PAT
# GIT_REPO_1_URL="https://github.com/Stephvan/lifebitdemo.git"
# GIT_REPO_2_URL="https://github.com/Stephvan/lifebit-source-code.git"
# FOLDER_1="repo_1_folder"
# FOLDER_2="repo_2_folder"
# PARENT_FOLDER="CICD-Demo"
# GIT_BRANCH="dev"
# GITHUB_PAT="YOUR_GITHUB_PAT_HERE"

# # Function to clone Git repo and checkout the specified branch
# clone_and_checkout() {
#   local repo_url=$1
#   local folder=$2

#   echo "Cloning the Git repository: $repo_url..."
#   git clone $repo_url $folder
#   if [ $? -ne 0 ]; then
#     echo "Error: Failed to clone Git repository: $repo_url. Are you using the right credential or the right Gihub URL"
#     exit 1
#   fi

#   cd $folder
#   git checkout $GIT_BRANCH
#   if [ $? -ne 0 ]; then
#     echo "Error: Failed to switch to the '$GIT_BRANCH' branch in Git repository: $repo_url"
#     exit 1
#   fi
#   echo "Git repository cloned and switched to the '$GIT_BRANCH' branch."
#   cd ..
# }

# # Create a parent directory to store the cloned repositories
# mkdir -p $PARENT_FOLDER
# cd $PARENT_FOLDER

# # Clone the first Git repo with authentication
# export GIT_ASKPASS="/usr/bin/echo"
# export GIT_USERNAME="your_username"
# export GIT_PASSWORD="$GITHUB_PAT"
# export GIT_TERMINAL_PROMPT=1
# clone_and_checkout $GIT_REPO_1_URL $FOLDER_1

# # Clone the second Git repo with authentication
# export GIT_ASKPASS="/usr/bin/echo"
# export GIT_USERNAME="your_username"
# export GIT_PASSWORD="$GITHUB_PAT"
# export GIT_TERMINAL_PROMPT=1
# clone_and_checkout $GIT_REPO_2_URL $FOLDER_2

# # Add a line to go into the Terraform folder and run the run_terraform.sh script
# cd $FOLDER_1/Infra/Terraform
# chmod +x run_terraform.sh
# ./run_terraform.sh
# if [ $? -ne 0 ]; then
#   echo "Error: Failed to execute the Terraform script."
#   exit 1
# fi
#
# echo "Both Git repositories cloned and checked out on the '$GIT_BRANCH' branch. Terraform script executed successfully."