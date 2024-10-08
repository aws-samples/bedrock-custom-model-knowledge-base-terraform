# Use data sources to get common information about the environment
data "aws_caller_identity" "this" {}
data "aws_partition" "this" {}
data "aws_region" "this" {}

data "aws_iam_policy_document" "bedrock_custom_policy" {
  statement {
    sid       = "AllowS3Access"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
    resources = [var.custom_model_s3_arn, "${var.custom_model_s3_arn}/*"]
  }
}

