variable "kb_oss_collection_name" {
  type        = string
  description = "The name of the collection for the Knowledge Base Open Source Software (OSS) content."
}

variable "bedrock_role_arn" {
  type        = string
  description = "The Amazon Resource Name (ARN) of the IAM role that grants permissions to the Bedrock resources."
}

variable "index_name" {
  type        = string
  description = "The name of the OpenSearch index"
}