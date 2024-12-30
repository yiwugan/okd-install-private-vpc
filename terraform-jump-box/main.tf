terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  common-tags = {
    "application" = var.application
  }
}

data "aws_caller_identity" "current" {}

