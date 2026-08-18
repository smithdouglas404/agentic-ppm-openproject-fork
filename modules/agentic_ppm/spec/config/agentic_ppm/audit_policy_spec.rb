require "spec_helper"
require "yaml"

RSpec.describe "Agentic PPM audit policy" do
  let(:policy) do
    YAML.safe_load_file(Rails.root.join("config/agentic_ppm/audit_policy.yml"), aliases: true)
  end

  it "requires policy-controlled retention and authorized deletion evidence" do
    expect(policy.dig("retention", "default_classification")).to eq("governed_agentic_ppm_audit")
    expect(policy.dig("retention", "deletion_requires")).to include(
      "retention_policy_decision", "authorization_decision", "deletion_trigger", "correlation_id", "audit_tombstone"
    )
  end

  it "defines auditable exports without raw credentials" do
    expect(policy.dig("export", "required_fields")).to include(
      "workspace_id", "tenant_id", "project_id", "authorization_decision", "correlation_id", "source_references"
    )
    expect(policy.dig("export", "prohibit")).to include("raw_credentials", "session_tokens", "unscoped_cross_project_records")
    expect(policy.dig("regulated_clients", "require_export_manifest_hash")).to be(true)
  end
end
