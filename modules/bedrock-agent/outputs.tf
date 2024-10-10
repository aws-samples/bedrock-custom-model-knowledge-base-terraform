output "agent_id" {
  description = "The ID of the AWS CloudControl Agent resource."
  value       = awscc_bedrock_agent.sample_asst.agent_id
}