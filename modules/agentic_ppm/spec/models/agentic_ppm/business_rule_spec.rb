require "spec_helper"

RSpec.describe AgenticPpm::BusinessRule do
  let(:rule) do
    build_stubbed(
      :agentic_ppm_business_rule,
      state: "published",
      visual_flow_reference: "langflow://governance-v1",
      validation_result: {
        "valid" => true,
        "flow_reference" => "langflow://governance-v1",
        "flow_version" => "1",
        "validated_at" => "2026-08-18T00:00:00Z",
        "validator_identity" => "langflow",
        "policy_version" => "1"
      },
      simulation_trace: { "valid" => true, "trace_id" => "simulation-1" },
      authorization_decision: { "authorized" => true, "rule_id" => 9 }
    )
  end

  it "accepts complete published evidence" do
    expect(rule).to be_valid
  end

  it "rejects publication without a valid simulation trace" do
    rule.simulation_trace = {}

    expect(rule).not_to be_valid
    expect(rule.errors[:simulation_trace]).to include("must contain a valid trace for publication")
  end

  it "rejects publication without authorization evidence" do
    rule.authorization_decision = {}

    expect(rule).not_to be_valid
    expect(rule.errors[:authorization_decision]).to include("is required for publication")
  end
end
