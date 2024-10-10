#S3
module "s3_bucket" {
  source      = "./modules/s3"
  bucket_name = "${var.kb_s3_bucket_name_prefix}-${local.region_short}-${local.account_id}"
}

#Create bucket for custom model
module "custom_model_bucket" {
  source      = "./modules/s3"
  bucket_name = "sample-model-training-${local.region_short}-${local.account_id}"
}

# Knowledge base resource role
module "sample_iam" {
  source              = "./modules/iam"
  action_group_name   = var.action_group_name
  agent_name          = var.agent_name
  kb_name             = var.kb_name
  s3_arn              = module.s3_bucket.arn
  kb_model_arn        = data.aws_bedrock_foundation_model.kb.model_arn
  lambda_iam_policy   = data.aws_iam_policy.lambda_basic_execution.arn
  custom_model_s3_arn = module.custom_model_bucket.arn
}

module "custom-model-generation" {
  source                  = "./modules/custom-model"
  custom_model_bucket     = module.custom_model_bucket.bucket_name
  bedrock_custom_role_arn = module.sample_iam.bedrock_custom_role_arn
}

module "action_group_lambda" {
  source             = "./modules/lambda"
  action_group_name  = var.action_group_name
  lambda_role_arn    = module.sample_iam.lambda_role_arn
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids
}

module "opensearch" {
  source                 = "./modules/opensearch"
  kb_oss_collection_name = var.kb_oss_collection_name
  bedrock_role_arn       = module.sample_iam.bedrock_role_arn
  index_name             = "bedrock-knowledge-base-default-index"
}

resource "time_sleep" "delay" {
  depends_on      = [module.opensearch.opensearch_index_name]
  create_duration = "60s" 
}

module "knowledge-base" {
  source                = "./modules/knowledge-base"
  kb_name               = var.kb_name
  bedrock_role_arn      = module.sample_iam.bedrock_role_arn
  bedrock_role_name     = module.sample_iam.bedrock_role_name
  kb_model_arn          = data.aws_bedrock_foundation_model.kb.model_arn
  opensearch_arn        = module.opensearch.opensearch_collection_arn
  s3_arn                = module.s3_bucket.arn
  opensearch_index_name = module.opensearch.opensearch_index_name
  depends_on = [ time_sleep.delay ]
}

module "guardrails" {
  source = "./modules/guardrails"
  name   = "sample_guardrail"
}

module "bedrock-agent" {
  source                  = "./modules/bedrock-agent"
  agent_name              = var.agent_name
  agent_model_id          = var.agent_model_id
  kb_id                   = module.knowledge-base.kb_id
  guardrail_identifier    = module.guardrails.guardrail_identifier
  guardrail_version       = module.guardrails.guardrail_version
  action_group_lambda_arn = module.action_group_lambda.lambda_arn
  kb_arn                  = module.knowledge-base.kb_arn
}

resource "terraform_data" "sample_asst_prepare" {
  triggers_replace = {
    sample_kb_state = sha256(jsonencode(module.knowledge-base))
  }
  provisioner "local-exec" {
    command = "aws bedrock-agent prepare-agent --agent-id ${module.bedrock-agent.agent_id}"
  }
}