# terraform {} (version, required_providers, empty backend "s3" {}) and provider "aws" with default_tags

terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  # Empty on purpose: bucket/key/region come from -backend-config at init time,
  # so one codebase serves both environments (one state key each).
  backend "s3" {}
}

provider "aws" {
  region = "eu-north-1"

  default_tags {
    tags = {
      Project     = "voting-app"
      Environment = var.env
      Owner       = var.name_prefix
    }
  }
}
