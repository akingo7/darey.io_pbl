terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.11.0"
    }
  }
   backend "s3" {
    bucket = "gabriel-devops-bucket"
    key    = "statefiles/terrafrom.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = var.region
}

provider "random" {
  
}

provider "kubernetes" {
host                   = data.aws_eks_cluster.cluster.endpoint
cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
token                  = data.aws_eks_cluster_auth.cluster.token
}