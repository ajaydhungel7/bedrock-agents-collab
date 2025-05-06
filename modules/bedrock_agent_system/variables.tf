variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "existing_kb_bucket_name" {
  description = "Name of the existing S3 bucket for supplemental knowledge base chunk storage"
  type        = string
}