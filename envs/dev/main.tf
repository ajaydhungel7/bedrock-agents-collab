terraform {
  required_providers {
    opensearch = {
      source  = "opensearch-project/opensearch"
      version = "~> 2.3.0",
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.aws_region
}


module "bedrock_agents" {
  source = "../../modules/bedrock_agent_system"
  environment               = var.environment
  existing_kb_bucket_name   = var.existing_kb_bucket_name
  providers = {

    aws        = aws
  }
}