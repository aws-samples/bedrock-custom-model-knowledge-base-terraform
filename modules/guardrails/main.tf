#guardrail
resource "awscc_bedrock_guardrail" "sample" {
  name                      = var.name
  blocked_input_messaging   = "Blocked input"
  blocked_outputs_messaging = "Blocked output"
  description               = "sample guardrail"

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

resource "awscc_bedrock_guardrail_version" "sample" {
  guardrail_identifier = awscc_bedrock_guardrail.sample.guardrail_id
  description          = "sample guardrail version"
}