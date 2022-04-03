terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket = "gabriel-dev-terraform-bucket"
    key    = "terraform-project/stateFile"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = var.region
}