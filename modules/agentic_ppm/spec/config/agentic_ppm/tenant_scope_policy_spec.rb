require "spec_helper"
require "yaml"

RSpec.describe "Agentic PPM tenant scope policy" do
  let(:policy) do
    YAML.safe_load_file(Rails.root.join("config/agentic_ppm/tenant_scope_policy.yml"), aliases: true)
  end

  it "requires tenant, workspace, project, user, and authorization scope" do
    expect(policy.dig("scope_hierarchy", "required")).to include(
      "workspace_id", "tenant_id", "project_id", "openproject_user_id", "authorization_policy"
    )
  end

  it "denies cross-project access by default and requires provenance for exceptions" do
    expect(policy.dig("cross_project_access", "default")).to eq("deny")
    expect(policy.dig("cross_project_access", "required_evidence")).to include(
      "current_openproject_permission", "source_project_ids", "destination_project_ids", "authorization_provenance", "correlation_id"
    )
  end
end
