require "spec_helper"

RSpec.describe AgenticPpm::Agents::InvocationService do
  let(:project) { build_stubbed(:project, id: 42) }
  let(:user) { build_stubbed(:user) }

  it "persists an unavailable PMO request rather than fabricating an answer" do
    allow(AgenticPpm::ServiceRegistry).to receive(:adapter_for).with(:durable_workflow).and_return(double(capability_state: :disabled))
    allow(AgenticPpm::AgentRun).to receive(:create!).and_return(double)
    allow(AgenticPpm::AgentRunJob).to receive(:perform_later)

    result = described_class.new(project:, user:, specialist: "PMO", prompt: "What delivery risks require review?").call

    expect(result.available).to be(false)
    expect(AgenticPpm::AgentRun).to have_received(:create!).with(hash_including(specialist: "PMO", state: "unavailable"))
    expect(AgenticPpm::AgentRunJob).not_to have_received(:perform_later)
  end

  it "enqueues a native autonomous PMO run when the local runtime is configured" do
    run = double(id: 99)
    allow(AgenticPpm::ServiceRegistry).to receive(:adapter_for).with(:durable_workflow).and_return(double(capability_state: :configured))
    allow(AgenticPpm::AgentRun).to receive(:create!).and_return(run)
    allow(AgenticPpm::AgentRunJob).to receive(:perform_later)

    with_env(
      "AGENTIC_PPM_AGENT_RUNTIME_BASE_URL" => "http://agent-runtime:8000",
      "AGENTIC_PPM_AGENT_RUNTIME_KEY" => "test-agent-key"
    ) do
      result = described_class.new(project:, user:, specialist: "PMO", prompt: "Assess delivery readiness").call

      expect(result.available).to be(true)
      expect(AgenticPpm::AgentRun).to have_received(:create!).with(hash_including(
        project:,
        user:,
        specialist: "PMO",
        state: "requested",
        evidence_references: []
      ))
      expect(AgenticPpm::AgentRunJob).to have_received(:perform_later).with(99)
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
