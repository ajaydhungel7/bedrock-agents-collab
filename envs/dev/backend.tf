terraform {
  backend "s3" {
    bucket = "bedrock-terraform-backend"
    key    = "bedrock/dev/terraform.tfstate"
    region = "us-east-1"
  }
}