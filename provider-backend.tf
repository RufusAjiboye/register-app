terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "techbleats-terraform-state-files"
    key    = "hrapp/terraform.tfstate"
    region = "eu-west-1"
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-1"
}


























# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.67.0"
#     }
#   }

#   backend "s3" {
#     bucket = "techbleats-terraform-state-files"
#     key    = "hrapp/terraform.tfstate"
#     region = "eu-west-1"
#   }

#   required_version = ">= 1.2.0"
# }

# provider "aws" {
#   region = "eu-west-1"
# }
