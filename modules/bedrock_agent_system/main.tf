terraform {
  required_providers {
    opensearch = {
      source  = "opensearch-project/opensearch"
      version = "~> 2.3.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "opensearch" {
  url         = "https://j7nrf7tugpf3nave02t1.us-east-1.aoss.amazonaws.com"
  healthcheck = false
}
