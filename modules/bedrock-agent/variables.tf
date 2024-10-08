variable "agent_model_id" {
  description = "The ID of the foundational model used by the agent."
  type        = string
  default     = "anthropic.claude-3-haiku-20240307-v1:0"
}

variable "agent_name" {
  description = "The name of the agent."
  type        = string
}

variable "kb_id" {
  description = "The ID of the knowledge base associated with the agent."
  type        = string
}

variable "guardrail_identifier" {
  description = "The identifier of the guardrail used by the agent."
  type        = string
}

variable "guardrail_version" {
  description = "The version of the guardrail used by the agent."
  type        = string
}

variable "action_group_lambda_arn" {
  description = "The Amazon Resource Name (ARN) of the Lambda function associated with the action group."
  type        = string
}

variable "action_group_name" {
  description = "The name of the action group."
  type        = string
  default     = "hashicorpAPI"
}

variable "action_group_desc" {
  description = "The description of the action group."
  type        = string
  default     = "An assistant that provides hashicorp information."
}

variable "kb_arn" {
  description = "The Amazon Resource Name (ARN) of the knowledge base associated with the agent."
  type        = string
}