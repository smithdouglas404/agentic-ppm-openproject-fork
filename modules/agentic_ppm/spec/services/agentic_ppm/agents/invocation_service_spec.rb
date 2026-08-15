require "spec_helper"

RSpec.describe AgenticPpm::Agents::InvocationService do
  let(:project) { build_stubbed(:project) }
  let(:user) { build_stubbed(:user) }

  it "persists an unavailable PMO request rather than fabricating an answer" do
    allow(AgenticPpm::ServiceRegistry).to receive(:adapter_for).with(:letta).and_return(double(capability_state: :disabled))
    allow(AgenticPpm::AgentRun).to receive(:create!).and_return(double)

    result = described_class.new(project:, user:, specialist: "PMO", prompt: "What delivery risks require review?").call

    expect(result.available).to be(false)
    expect(AgenticPpm::AgentRun).to have_received(:create!).with(hash_including(specialist: "PMO", state: "unavailable"))
  end
end
