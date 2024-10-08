output "lambda_arn" {
  description = "The Amazon Resource Name (ARN) of the Lambda function."
  value       = aws_lambda_function.hashicorp_api.arn
}