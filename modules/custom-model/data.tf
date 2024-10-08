data "aws_caller_identity" "this" {}
data "aws_partition" "this" {}
data "aws_region" "this" {}

data "aws_bedrock_foundation_model" "cohere_command_light_text_v14" {
  model_id = "cohere.command-light-text-v14:7:4k"
}