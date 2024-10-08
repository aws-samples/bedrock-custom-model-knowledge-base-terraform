variable "kb_name" {
  type        = string
  description = "The name of the Knowledge Base"
}

variable "s3_arn" {
  type        = string
  description = "The ARN of the S3 bucket"
}

variable "bedrock_role_arn" {
  type        = string
  description = "The ARN of the Bedrock role"
}

variable "bedrock_role_name" {
  type        = string
  description = "The name of the Bedrock role"
}

variable "kb_model_arn" {
  type        = string
  description = "The ARN of the Knowledge Base model"
}

variable "opensearch_arn" {
  type        = string
  description = "The ARN of the OpenSearch domain"
}

variable "opensearch_index_name" {
  type        = string
  description = "The name of the OpenSearch index"
}