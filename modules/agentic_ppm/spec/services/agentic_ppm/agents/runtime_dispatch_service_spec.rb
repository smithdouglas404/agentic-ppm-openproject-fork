require "spec_helper"

RSpec.describe AgenticPpm::Agents::RuntimeDispatchService do
  let(:run) do
    instance_double(
      AgenticPpm::AgentRun,
      specialist: "PMO",
      project_id: 42,
      correlation_id: "corr-42"
    )
  end

  it "dispatches a project-scoped PMO request to the protected local runtime" do
    http_client = instance_double(AgenticPpm::Integrations::HttpClient)
    allow(AgenticPpm::Integrations::HttpClient).to receive(:new).with(
      base_url: "http://agent-runtime:8000",
      authorization: nil
    ).and_return(http_client)
    allow(http_client).to receive(:post).and_return("status" => "running", "job_id" => "pmo-42")

    with_env(
      "AGENTIC_PPM_AGENT_RUNTIME_BASE_URL" => "http://agent-runtime:8000",
      "AGENTIC_PPM_AGENT_RUNTIME_KEY" => "test-agent-key",
      "AGENTIC_PPM_ALLOW_INSECURE_SERVICE_URLS" => "true"
    ) do
      result = described_class.new(run:).call

      expect(result).to include("status" => "running", "job_id" => "pmo-42")
      expect(http_client).to have_received(:post).with(
        "/api/agents/pmo/run",
        payload: {
          trigger: "OpenProject AgentRun corr-42",
          project_id: "42",
          scope: "project:42"
        },
        headers: { "X-Agent-Key" => "test-agent-key" }
      )
    end
  end

  private

  def with_env(values)
    previous = values.to_h { |key, _value| [key, ENV[key]] }
    values.each { |key, value| ENV[key] = value }
    yield
  ensure
    previous.each { |key, value| value.nil? ? ENV.delete(key) : ENV[key] = value }
  end
end
