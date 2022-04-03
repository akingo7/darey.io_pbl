terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket = "gabriel-devops-terraform"
    key    = "global/s3/terraform.tfstate"
    region = "eu-central-1"
    # dynamodb_table = "terraform-locks"
    encrypt = true

  }

}

provider "aws" {
  region = var.region
}