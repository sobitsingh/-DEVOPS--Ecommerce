variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1" # Change this to your desired region
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket for Terraform state"
  type        = string
  # add aws account id to bucket name to make it unique
    #default     = "backend-${data.aws_caller_identity.current.account_id}" 
    default = "backend-058264397013"
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table for Terraform state locking"
  type        = string
  default     = "terraform-locks" # Replace with your desired table name
}

variable "environment" {
  description = "The environment for tagging (e.g., dev, prod)"
  type        = string
  default     = "dev"
}