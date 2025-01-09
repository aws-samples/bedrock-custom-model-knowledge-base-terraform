resource "aws_s3_object" "v1_training_fine_tune" {
  bucket = var.custom_model_bucket
  key    = "training_data_v1/banking_qa.jsonl"
  source = "banking_qa.jsonl"
}

# resource "terraform_data" "training_data_fine_tune_v1" {
#   input = "banking_qa.jsonl"

#   provisioner "local-exec" {
#     command = "pip3 install datasets && python ${path.module}/bank_qa.py"
#   }
# }

resource "time_sleep" "iam_consistency_delay" {
  create_duration = "120s"
  depends_on      = [aws_s3_object.v1_training_fine_tune]
}

resource "aws_bedrock_custom_model" "cm_cohere_v1" {
  custom_model_name     = "cm_cohere_v001-${local.region_short}-${local.account_id}"
  job_name              = "cm.command-light-text-v14.v001--${local.region_short}-${local.account_id}-${random_integer.suffix.result}"
  base_model_identifier = data.aws_bedrock_foundation_model.cohere_command_light_text_v14.model_arn
  role_arn              = var.bedrock_custom_role_arn
  customization_type    = "FINE_TUNING"

  hyperparameters = {
    "epochCount"             = "1"
    "batchSize"              = "8"
    "learningRate"           = "0.00001"
    "earlyStoppingPatience"  = "6"
    "earlyStoppingThreshold" = "0.01"
    "evalPercentage"         = "20.0"
  }

  output_data_config {
    s3_uri = "s3://${var.custom_model_bucket}/output_data_v1/"
  }

  training_data_config {
    s3_uri = "s3://${var.custom_model_bucket}/training_data_v1/banking_qa.jsonl"
  }
  depends_on = [aws_s3_object.v1_training_fine_tune]
}

resource "random_integer" "suffix" {
  min = 23
  max = 50000

}
