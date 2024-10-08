# Use data sources to get common information about the environment
data "aws_caller_identity" "this" {}
data "aws_partition" "this" {}
data "aws_region" "this" {}

data "archive_file" "hashicorp_api_zip" {
  type             = "zip"
  source_file      = "${path.module}/files/index.py"
  output_path      = "${path.module}/files/hashicorp_api.zip"
  output_file_mode = "0666"
}