require "spec_helper"

RSpec.describe AgenticPpm::ServiceAdapters::LangflowAdapter do
  let(:http_client) { instance_double(AgenticPpm::Integrations::HttpClient) }
  let(:adapter) { described_class.new(http_client: http_client) }
  let(:project) { instance_double(Project, id: 42) }
  let(:actor) { instance_double(User, id: 7) }
  let(:rule) do
    instance_double(
      AgenticPpm::BusinessRule,
      id: 9,
      name: "Require delivery evidence",
      category: "governance",
      definition: { "condition" => "missing_schedule" },
      visual_flow_reference: "flow://governance/12"
    )
  end

  around do |example|
    original = ENV.to_h.slice("LANGFLOW_AGENTIC_ENABLED", "LANGFLOW_BASE_URL", "LANGFLOW_API_KEY")
    example.run
  ensure
    %w[LANGFLOW_AGENTIC_ENABLED LANGFLOW_BASE_URL LANGFLOW_API_KEY].each { |key| ENV.delete(key) }
    original.each { |key, value| ENV[key] = value }
  end

  it "reports disabled when the service is not explicitly enabled" do
    ENV.delete("LANGFLOW_AGENTIC_ENABLED")

    expect(adapter.capability_state).to eq(:disabled)
  end

  it "posts a policy-scoped validation payload when configured" do
    ENV["LANGFLOW_AGENTIC_ENABLED"] = "true"
    ENV["LANGFLOW_BASE_URL"] = "https://langflow.internal"
    allow(http_client).to receive(:post).and_return({ "valid" => true })

    result = adapter.validate_rule(rule: rule, actor: actor, project: project)

    expect(result).to eq("valid" => true)
    expect(http_client).to have_received(:post).with(
      "/api/v1/flows/validate",
      payload: hash_including(
        "project_id" => 42,
        "rule_id" => 9,
        "actor_id" => 7,
        "policy_version" => "1"
      ),
      headers: { "X-OpenProject-Policy-Version" => "1" }
    )
  end

  it "marks simulation input as authorized sanitized or synthetic data" do
    ENV["LANGFLOW_AGENTIC_ENABLED"] = "true"
    ENV["LANGFLOW_BASE_URL"] = "https://langflow.internal"
    allow(http_client).to receive(:post).and_return({ "valid" => true, "trace_id" => "sim-1" })

    adapter.simulate_rule(rule: rule, actor: actor, project: project, source_data: { "records" => [] })

    expect(http_client).to have_received(:post).with(
      "/api/v1/flows/simulate",
      payload: hash_including("source_data_mode" => "authorized_sanitized_or_synthetic_only"),
      headers: { "X-OpenProject-Policy-Version" => "1" }
    )
  end
end
