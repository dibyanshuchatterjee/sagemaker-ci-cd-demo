
module "account-ids" {
  source  = "app.terraform.io/uopx/account-ids/aws"
  version = "0.0.3"
  environment = var.environment
}

provider "aws" {

  region = "us-east-1"

  assume_role {
    role_arn     = "arn:aws:iam::${module.account-ids.id}:role/role_name"
    session_name = "demo-sagemaker-prod" 
  }
}

