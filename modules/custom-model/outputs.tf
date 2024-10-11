output "custom_model_arn" {
  description = "The ARN of the custom model"
  value       = aws_bedrock_custom_model.cm_cohere_v1.custom_model_arn
}