require "spec_helper"
require "yaml"

RSpec.describe "Agentic PPM model provider policy" do
  let(:policy) do
    YAML.safe_load_file(Rails.root.join("config/agentic_ppm/model_provider_policy.yml"), aliases: true)
  end

  it "prefers Claude-capable Anthropic without hard-coding an active single-vendor runtime" do
    expect(policy.fetch("default_provider_preference")).to eq("anthropic")
    expect(policy.fetch("provider_order")).to include("anthropic", "openai_compatible", "local_approved")
    expect(policy.fetch("providers").values).to all(include("status" => "requires_authorized_activation"))
  end

  it "requires normalized authorized context, blocks unsafe fallback, and gates activation on evaluation" do
    expect(policy.dig("normalization_contract", "required_request_fields")).to include(
      "authorization_context", "evidence_references", "correlation_id", "token_limit"
    )
    expect(policy.dig("fallback_policy", "never_fallback_for")).to include(
      "write_or_transactional_actions", "evidence_context_without_authorization_provenance"
    )
    expect(policy.dig("evaluation_contract", "release_gate")).to eq("required_before_provider_activation")
  end
end
