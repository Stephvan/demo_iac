function Check-Command {
    param([string]$command)

    if (-Not (Get-Command $command -ErrorAction SilentlyContinue)) {
        Write-Host "Error: $command command not found. Please install it and try again."
        exit 1
    }
}

Clear-Host

# Check if Terraform is installed
Check-Command "terraform"

# Cleanup - remove any existing plan file
Remove-Item *.tfplan -ErrorAction SilentlyContinue
Remove-Item *.hcl -ErrorAction SilentlyContinue
Remove-Item *.tfstate -ErrorAction SilentlyContinue
Remove-Item *.tfstate.backup -ErrorAction SilentlyContinue

# Initialize Terraform
Write-Host "Initializing Terraform..."
terraform init

# Plan and save the plan to a file
Write-Host "Creating Terraform plan..."
terraform plan -out=my_plan.tfplan

# Print Terraform debug information
Write-Host "Printing Terraform debug information..."
$env:TF_LOG = "DEBUG"

# Apply the plan with debug output
Write-Host "Applying Terraform plan..."
#terraform apply -input=false "my_plan.tfplan"

# Cleanup - remove the plan file
Remove-Item my_plan.tfplan -ErrorAction SilentlyContinue

Write-Host "Terraform apply completed successfully."
