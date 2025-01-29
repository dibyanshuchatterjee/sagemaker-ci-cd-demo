terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0, < 4.0"
    }
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "org"

    workspaces {
      name = "demo-sagemaker-"
    }
  }
}
