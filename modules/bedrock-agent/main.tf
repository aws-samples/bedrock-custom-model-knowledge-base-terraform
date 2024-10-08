resource "awscc_bedrock_agent" "hashicorp_asst" {
  agent_name              = var.agent_name
  description             = "hashicorp agent configuration"
  agent_resource_role_arn = aws_iam_role.bedrock_agent_hashicorp_asst.arn
  foundation_model        = data.aws_bedrock_foundation_model.agent.model_id
  instruction             = file("${path.module}/instruction.txt")
  knowledge_bases = [{
    description          = "hashicorp knowledge base"
    knowledge_base_id    = var.kb_id
    knowledge_base_state = "ENABLED"
  }]
  guardrail_configuration = {
    guardrail_identifier = var.guardrail_identifier
    guardrail_version    = var.guardrail_version
  }
  idle_session_ttl_in_seconds = 600
  auto_prepare                = true
  action_groups = [{
    action_group_name = var.action_group_name
    description       = var.action_group_desc
    function_schema = {
      functions = [{
        name        = "hashicorp-function"
        description = "Hashicorp function"
        parameters = {
          param1 = {
            type        = "string"
            description = "The first parameter"
            required    = true
          }
          param2 = {
            type        = "integer"
            description = "The second parameter"
            required    = false
          }
        }
        return_value = {
          type        = "string"
          description = "The return value"
        }
      }]
    }
    action_group_executor = {
      lambda = var.action_group_lambda_arn
    }
  }]

  tags = {
    "Modified By" = "AWSCC"
  }

}

# Agent resource role
resource "aws_iam_role" "bedrock_agent_hashicorp_asst" {
  name = "AmazonBedrockExecutionRoleForAgents_${var.agent_name}"
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
            "aws:SourceArn" = "arn:${local.partition}:bedrock:${local.region}:${local.account_id}:agent/*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "bedrock_agent_hashicorp_asst_model" {
  name = "AmazonBedrockAgentBedrockFoundationModelPolicy_${var.agent_name}"
  role = aws_iam_role.bedrock_agent_hashicorp_asst.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "bedrock:InvokeModel"
        Effect   = "Allow"
        Resource = data.aws_bedrock_foundation_model.agent.model_arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "bedrock_agent_hashicorp_asst_kb" {
  name = "AmazonBedrockAgentBedrockKnowledgeBasePolicy_${var.agent_name}"
  role = aws_iam_role.bedrock_agent_hashicorp_asst.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "bedrock:Retrieve"
        Effect   = "Allow"
        Resource = var.kb_arn
      }
    ]
  })
}