require "spec_helper"
require "yaml"

RSpec.describe "Agentic PPM service health policy" do
  let(:policy) do
    YAML.safe_load_file(Rails.root.join("config/agentic_ppm/service_health_policy.yml"), aliases: true)
  end

  it "defines every required supporting service and fail-closed defaults" do
    expect(policy.dig("defaults", "failure_mode")).to eq("explicit_capability_state")
    expect(policy.dig("defaults", "never_claim_ready_on_missing_credentials")).to be(true)
    expect(policy.fetch("services").keys).to include(
      "openproject", "agent_runtime", "letta", "mem0", "memgraph", "langflow", "litellm", "connectors", "graph_projection"
    )
  end

  it "defines explicit states and auditable health fields" do
    expect(policy.fetch("states").keys).to include("healthy", "configured", "degraded", "unavailable", "syncing")
    expect(policy.dig("observability", "required_fields")).to include(
      "service", "state", "checked_at", "correlation_id", "authorization_decision", "failure_classification"
    )
  end
end
