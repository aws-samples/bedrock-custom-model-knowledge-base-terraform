#guardrail
resource "awscc_bedrock_guardrail" "hashicorp" {
  name                      = var.name
  blocked_input_messaging   = "Blocked input"
  blocked_outputs_messaging = "Blocked output"
  description               = "hashicorp guardrail"

  content_policy_config = {
    filters_config = [
      {
        input_strength  = "MEDIUM"
        output_strength = "MEDIUM"
        type            = "HATE"
      },
      {
        input_strength  = "HIGH"
        output_strength = "HIGH"
        type            = "VIOLENCE"
      }
    ]
  }
}

resource "awscc_bedrock_guardrail_version" "hashicorp" {
  guardrail_identifier = awscc_bedrock_guardrail.hashicorp.guardrail_id
  description          = "hashicorp guardrail version"
}