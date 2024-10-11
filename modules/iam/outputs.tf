output "bedrock_role_arn" {
  description = "ARN of the Bedrock IAM role"
  value       = aws_iam_role.bedrock_kb_sample_kb.arn
}

output "bedrock_role_name" {
  description = "Name of the Bedrock IAM role"
  value       = aws_iam_role.bedrock_kb_sample_kb.name
}

output "lambda_role_arn" {
  description = "ARN of the Lambda IAM role"
  value       = aws_iam_role.lambda_sample_api.arn
}

output "bedrock_custom_role_arn" {
  description = "ARN of the bedrock custom model IAM role"
  value       = aws_iam_role.bedrock_custom_role.arn
}