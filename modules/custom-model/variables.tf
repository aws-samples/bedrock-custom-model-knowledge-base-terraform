variable "custom_model_bucket" {
  type        = string
  description = "Name of the bucket used"
}

variable "bedrock_custom_role_arn" {
  type        = string
  description = "ARN of the custom role used with Bedrock"
}