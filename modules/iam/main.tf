resource "aws_iam_role" "bedrock_kb_hashicorp_kb" {
  name = "AmazonBedrockExecutionRoleForKnowledgeBase_${var.kb_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "bedrock.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = local.account_id
          }
          ArnLike = {
            "aws:SourceArn" = "arn:${local.partition}:bedrock:${local.region}:${local.account_id}:knowledge-base/*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "bedrock_kb_hashicorp_kb_model" {
  name = "AmazonBedrockFoundationModelPolicyForKnowledgeBase_${var.kb_name}"
  role = aws_iam_role.bedrock_kb_hashicorp_kb.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "bedrock:InvokeModel"
        Effect   = "Allow"
        Resource = var.kb_model_arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "bedrock_kb_hashicorp_kb_s3" {
  name = "AmazonBedrockS3PolicyForKnowledgeBase_${var.kb_name}"
  role = aws_iam_role.bedrock_kb_hashicorp_kb.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "S3ListGetPutObjectStatement"
        Action   = ["s3:List*", "s3:Get*", "s3:PutObject"]
        Effect   = "Allow"
        Resource = [var.s3_arn, var.custom_model_s3_arn, "${var.s3_arn}/*", "${var.custom_model_s3_arn}/*"]
        Condition = {
          StringEquals = {
            "aws:PrincipalAccount" = local.account_id
          }
      } },
      {
        Sid      = "KMSPermissions"
        Action   = ["kms:*"]
        Effect   = "Allow"
        Resource = ["*"]
      }
    ]
  })
}


#Action group Lambda execution role
resource "aws_iam_role" "lambda_hashicorp_api" {
  name = "FunctionExecutionRoleForLambda_${var.action_group_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = local.account_id
          }
        }
      }
    ]
  })
  managed_policy_arns = [var.lambda_iam_policy]
}

#custom model policy
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["bedrock.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.this.account_id]
    }
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${local.partition}:bedrock:${local.region}:${local.account_id}:model-customization-job/*"]
    }
  }
}

resource "aws_iam_policy" "bedrock_custom_policy" {
  name_prefix = "BedrockCM-"
  description = "Policy for Bedrock Custom Models customization jobs"
  policy      = data.aws_iam_policy_document.bedrock_custom_policy.json
}

resource "aws_iam_role" "bedrock_custom_role" {
  name_prefix         = "BedrockCM-"
  description         = "Role for Bedrock Custom Models customization jobs"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_policy.json
  managed_policy_arns = [aws_iam_policy.bedrock_custom_policy.arn]
}