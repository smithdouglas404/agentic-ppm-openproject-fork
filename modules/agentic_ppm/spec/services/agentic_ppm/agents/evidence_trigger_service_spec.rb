require "spec_helper"

RSpec.describe AgenticPpm::Agents::EvidenceTriggerService do
  let(:project) { build_stubbed(:project, id: 42) }
  let(:system_user) { build_stubbed(:user, id: 1) }

  it "does not create an autonomous run when the local runtime is unavailable" do
    allow(AgenticPpm::ServiceRegistry).to receive(:adapter_for).with(:durable_workflow).and_return(double(capability_state: :disabled))
    expect(AgenticPpm::Agents::InvocationService).not_to receive(:new)

    result = described_class.new(project:, idempotency_key: "projection-1").call

    expect(result).to eq(available: false, reason: "agent_runtime_not_configured")
  end

  it "creates one system-owned PMO run for a new projected evidence key" do
    allow(AgenticPpm::ServiceRegistry).to receive(:adapter_for).with(:durable_workflow).and_return(double(capability_state: :configured))
    allow(User).to receive(:system).and_return(system_user)
    allow(AgenticPpm::AgentRun).to receive(:find_by).and_return(nil)
    invocation = instance_double(AgenticPpm::Agents::InvocationService, call: :queued)
    allow(AgenticPpm::Agents::InvocationService).to receive(:new).and_return(invocation)

    with_env(
      "AGENTIC_PPM_AGENT_RUNTIME_BASE_URL" => "http://agent-runtime:8000",
      "AGENTIC_PPM_AGENT_RUNTIME_KEY" => "test-agent-key"
    ) do
      result = described_class.new(project:, idempotency_key: "projection-1").call

      expect(result).to eq(:queued)
      expect(AgenticPpm::Agents::InvocationService).to have_received(:new).with(
        project:,
        user: system_user,
        specialist: "PMO",
        prompt: include("newly projected OpenProject evidence"),
        correlation_id: "pmo-evidence:42:projection-1"
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
