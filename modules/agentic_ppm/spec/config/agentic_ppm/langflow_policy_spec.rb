require "spec_helper"
require "yaml"

RSpec.describe "Agentic PPM Langflow visual governance policy" do
  let(:policy) do
    YAML.safe_load_file(Rails.root.join("config/agentic_ppm/langflow_policy.yml"), aliases: true)
  end

  it "keeps native project permissions and lifecycle controls authoritative" do
    expect(policy.dig("authorization", "project_scope_required")).to be(true)
    expect(policy.dig("authorization", "publish_permission")).to eq("manage_agentic_ppm_rules")
    expect(policy.dig("publication", "require_native_lifecycle_service")).to be(true)
    expect(policy.dig("publication", "prohibit_visual_flow_permission_bypass")).to be(true)
  end

  it "requires versioned external validation and traced safe simulation before publication" do
    expect(policy.dig("validation", "required_result_fields")).to include(
      "flow_reference", "flow_version", "validator_identity", "policy_version"
    )
    expect(policy.dig("validation", "simulation")).to include(
      "required_before_publish" => true,
      "require_simulation_trace" => true
    )
    expect(policy.dig("rollback", "require_previous_published_evidence")).to be(true)
  end
end
