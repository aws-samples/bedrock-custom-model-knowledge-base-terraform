# Action group Lambda function
resource "aws_lambda_function" "sample_api" {
  #checkov:skip=CKV_AWS_116: "Ensure that AWS Lambda function is configured for a Dead Letter Queue(DLQ)"
  #checkov:skip=CKV_AWS_115: "Ensure that AWS Lambda function is configured for function-level concurrent execution limit"
  #checkov:skip=CKV_AWS_272: "Ensure AWS Lambda function is configured to validate code-signing"
  function_name = var.action_group_name
  role          = var.lambda_role_arn
  description   = "A Lambda function for the action group ${var.action_group_name}"
  filename      = data.archive_file.sample_api_zip.output_path
  handler       = "index.lambda_handler"
  runtime       = "python3.12"
  # source_code_hash is required to detect changes to Lambda code/zip
  source_code_hash = data.archive_file.sample_api_zip.output_base64sha256
  tracing_config {
    mode = "Active"
  }
  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }
}

resource "aws_lambda_permission" "sample_api" {
  action         = "lambda:invokeFunction"
  function_name  = aws_lambda_function.sample_api.function_name
  principal      = "bedrock.amazonaws.com"
  source_account = local.account_id
  source_arn     = "arn:${local.partition}:bedrock:${local.region}:${local.account_id}:agent/*"
}