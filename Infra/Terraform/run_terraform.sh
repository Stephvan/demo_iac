#!/bin/bash

# Function to check if a command is available
check_command() {
  if ! command -v "$1" &> /dev/null; then
    echo "Error: $1 command not found. Please install it and try again."
    exit 1
  fi
}

clear

# Check if Terraform is installed
check_command "terraform"

# Cleanup - remove any existing plan file
rm *.tfplan
rm *.hcl
rm *.tfstate
rm *.tfstate.backup

# Initialize Terraform
echo "Initializing Terraform..."
terraform init

# Plan and save the plan to a file
echo "Creating Terraform plan..."
terraform plan -out=my_plan.tfplan

# Print Terraform debug information
echo "Printing Terraform debug information..."
export TF_LOG=DEBUG

# Apply the plan with debug output
echo "Applying Terraform plan..."
#terraform apply -input=false "my_plan.tfplan"

# Cleanup - remove the plan file
rm my_plan.tfplan

echo "Terraform apply completed successfully."
