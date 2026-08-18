require "spec_helper"
require "yaml"

RSpec.describe "Agentic PPM tool policy" do
  let(:policy) do
    YAML.safe_load_file(Rails.root.join("config/agentic_ppm/tool_policy.yml"), aliases: true)
  end

  it "denies unknown tools and requires project-scoped context" do
    expect(policy.fetch("default_decision")).to eq("deny")
    expect(policy.fetch("source_scopes").fetch("required")).to include(
      "workspace_id", "project_id", "openproject_user_id", "authorization_policy", "correlation_id"
    )
    expect(policy.dig("allowed_tools", "query_memgraph", "requires_project_scope")).to be(true)
    expect(policy.dig("allowed_tools", "retrieve_mem0", "requires_citations")).to be(true)
  end

  it "requires governed approval and native lifecycle for mutations" do
    expect(policy.dig("allowed_tools", "write_mem0", "requires_trace_event")).to be(true)
    expect(policy.dig("governed_mutations", "require_human_approval")).to be(true)
    expect(policy.dig("governed_mutations", "require_native_openproject_lifecycle")).to be(true)
    expect(policy.dig("model_providers", "direct_provider_calls")).to eq("deny")
  end
end
