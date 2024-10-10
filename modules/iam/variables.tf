variable "kb_name" {
  description = "The knowledge base name."
  type        = string
  default     = "sample"
}

variable "agent_name" {
  description = "The agent name."
  type        = string
  default     = "sampleAssistant"
}

variable "action_group_name" {
  description = "The action group name."
  type        = string
  default     = "sampleAPI"
}

variable "lambda_iam_policy" {
  type = string
}

variable "s3_arn" {
  type = string
}

variable "kb_model_arn" {
  type = string
}

variable "custom_model_s3_arn" {
  type = string
}