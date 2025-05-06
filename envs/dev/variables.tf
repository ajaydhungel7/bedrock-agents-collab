variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region for deployment"
  default     = "us-east-1"
}


variable "existing_kb_bucket_name" {
  default     = "knowledge-base-agents-bedrock"
  description = "Pre-created S3 bucket for document storage"
}