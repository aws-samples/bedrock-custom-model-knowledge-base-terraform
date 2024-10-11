variable "action_group_name" {
  type        = string
  description = "The name of the action group for monitoring alerts."
}

variable "lambda_role_arn" {
  type        = string
  description = "The Amazon Resource Name (ARN) of the IAM role for the Lambda function."
}

variable "subnet_ids" {
  type        = list(string)
  description = "The list of subnet IDs where the Lambda function will be deployed."
}

variable "security_group_ids" {
  type        = list(string)
  description = "The list of security group IDs to be associated with the Lambda function."
}