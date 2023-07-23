provider "aws" {
    #access_key=var.aws_access_key
    #secret_key=var.aws_secret_key
    region = var.networking.region
    
    ## Below is when using AWS profile
    #shared_credentials_files = ["%USERPROFILE%/.aws/credentials"]
    shared_credentials_files = ["$HOME/.aws/credentials"]
    profile                  = "default"
}