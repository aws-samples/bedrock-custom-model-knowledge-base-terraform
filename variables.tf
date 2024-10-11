variable "kb_s3_bucket_name_prefix" {
  description = "The name prefix of the S3 bucket for the data source of the knowledge base."
  type        = string
  default     = "sample-kb"
}

variable "kb_oss_collection_name" {
  description = "The name of the OpenSearch Service (OSS) collection for the knowledge base."
  type        = string
  default     = "bedrock-sample-kb"
}

variable "kb_model_id" {
  description = "The ID of the foundational model used by the knowledge base."
  type        = string
  default     = "amazon.titan-embed-text-v1"
}

variable "kb_name" {
  description = "The name of the knowledge base."
  type        = string
  default     = "sample"
}

variable "agent_model_id" {
  description = "The ID of the foundational model used by the agent."
  type        = string
  default     = "anthropic.claude-3-haiku-20240307-v1:0"
}

variable "agent_name" {
  description = "The name of the agent."
  type        = string
  default     = "sampleAssistant"
}

variable "agent_desc" {
  description = "The description of the agent."
  type        = string
  default     = "An assistant that provides sample information."
}

variable "action_group_name" {
  description = "The name of the action group."
  type        = string
  default     = "sampleAPI"
}

variable "action_group_desc" {
  description = "The description of the action group."
  type        = string
  default     = "An action group that provides sample information."
}

variable "subnet_ids" {
  type        = list(string)
  description = "The list of subnet IDs where the Lambda function will be deployed."
}

variable "security_group_ids" {
  type        = list(string)
  description = "The list of security group IDs to be associated with the Lambda function."
}