# Production-Grade React App on AWS

Terraform root config using modules.

terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "react-app/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "your-terraform-lock-table"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../modules/vpc"
  # ...existing code...
}

module "ecr" {
  source = "../modules/ecr"
  # ...existing code...
}

module "alb" {
  source = "../modules/alb"
  # ...existing code...
}

module "asg" {
  source = "../modules/asg"
  # ...existing code...
}