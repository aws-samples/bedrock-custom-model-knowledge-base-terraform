resource "aws_iam_role_policy" "bedrock_kb_hashicorp_kb_model" {
  name = "AmazonBedrockOSSPolicyForKnowledgeBase_${var.kb_name}"
  role = var.bedrock_role_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["aoss:*"]
        Effect   = "Allow"
        Resource = [var.opensearch_arn]
      }
    ]
  })
}

resource "time_sleep" "iam_consistency_delay" {
  create_duration = "120s"
  depends_on      = [aws_iam_role_policy.bedrock_kb_hashicorp_kb_model]
}


resource "aws_bedrockagent_knowledge_base" "hashicorp_kb" {
  name     = var.kb_name
  role_arn = var.bedrock_role_arn
  knowledge_base_configuration {
    vector_knowledge_base_configuration {
      embedding_model_arn = var.kb_model_arn
    }
    type = "VECTOR"
  }
  storage_configuration {
    type = "OPENSEARCH_SERVERLESS"
    opensearch_serverless_configuration {
      collection_arn    = var.opensearch_arn
      vector_index_name = var.opensearch_index_name
      field_mapping {
        vector_field   = "bedrock-knowledge-base-default-vector"
        text_field     = "AMAZON_BEDROCK_TEXT_CHUNK"
        metadata_field = "AMAZON_BEDROCK_METADATA"
      }
    }
  }
  depends_on = [time_sleep.iam_consistency_delay, aws_iam_role_policy.bedrock_kb_hashicorp_kb_model]
}

resource "aws_bedrockagent_data_source" "hashicorp_kb" {
  knowledge_base_id = aws_bedrockagent_knowledge_base.hashicorp_kb.id
  name              = "${var.kb_name}DataSource"
  data_source_configuration {
    type = "S3"
    s3_configuration {
      bucket_arn = var.s3_arn
    }
  }
}