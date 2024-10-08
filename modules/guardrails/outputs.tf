output "guardrail_identifier" {
  description = "Identifier of the Bedrock Guardrail"
  value       = awscc_bedrock_guardrail.hashicorp.id
}

output "guardrail_version" {
  description = "Version of the Bedrock Guardrail"
  value       = awscc_bedrock_guardrail_version.hashicorp.version
}