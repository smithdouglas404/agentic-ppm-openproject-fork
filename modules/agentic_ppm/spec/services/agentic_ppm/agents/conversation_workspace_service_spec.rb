require "spec_helper"

RSpec.describe AgenticPpm::Agents::ConversationWorkspaceService do
  Run = Struct.new(:specialist, :prompt, keyword_init: true)

  let(:project) { instance_double(Project) }
  let(:contracts) do
    [
      { "invocation_key" => "PMO", "name" => "PMO Agent" },
      { "invocation_key" => "VRO", "name" => "VRO Agent" },
      { "invocation_key" => "OCM", "name" => "OCM Agent" }
    ]
  end

  it "exposes only the interactive PMO and VRO contracts, requested history, and inactive-runtime boundary" do
    allow(AgenticPpm::ServiceRegistry).to receive(:adapter_for).with(:letta).and_return(double(capability_state: :disabled))

    result = described_class.new(
      project: project,
      specialist_contracts: contracts,
      agent_runs: [Run.new(specialist: "PMO", prompt: "Assess delivery readiness")]
    ).call

    expect(result[:specialist_contracts].map { |contract| contract.fetch("invocation_key") }).to eq(%w[PMO VRO])
    expect(result[:agent_runs].map(&:specialist)).to eq(["PMO"])
    expect(result[:runtime_configured]).to be(false)
  end

  it "bounds rendered history to the workspace limit" do
    allow(AgenticPpm::ServiceRegistry).to receive(:adapter_for).with(:letta).and_return(double(capability_state: :configured))
    runs = Array.new(described_class::HISTORY_LIMIT + 1) { |index| Run.new(specialist: "VRO", prompt: "Prompt #{index}") }

    result = described_class.new(project: project, specialist_contracts: contracts, agent_runs: runs).call

    expect(result[:agent_runs].size).to eq(described_class::HISTORY_LIMIT)
    expect(result[:runtime_configured]).to be(true)
  end
end
