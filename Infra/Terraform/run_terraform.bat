@echo off

REM Function to check if a command is available
:CheckCommand
    setlocal
    set "command=%~1"

    where /q "%command%" || (
        echo Error: %command% command not found. Please install it and try again.
        exit /b 1
    )
    exit /b 0
:end

cls

REM Check if Terraform is installed
call :CheckCommand terraform

REM Cleanup - remove any existing plan file
del *.tfplan 2>NUL
del *.hcl 2>NUL
del *.tfstate 2>NUL
del *.tfstate.backup 2>NUL

REM Initialize Terraform
echo Initializing Terraform...
terraform init

REM Plan and save the plan to a file
echo Creating Terraform plan...
terraform plan -out=my_plan.tfplan

REM Print Terraform debug information
echo Printing Terraform debug information...
set "TF_LOG=DEBUG"

REM Apply the plan with debug output
echo Applying Terraform plan...
REM terraform apply -input=false "my_plan.tfplan"

REM Cleanup - remove the plan file
del my_plan.tfplan 2>NUL

echo Terraform apply completed successfully.
