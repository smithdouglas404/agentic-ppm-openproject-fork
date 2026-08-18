require "rails_helper"

RSpec.describe AgenticPpm::Agents::OpenprojectEvidenceHandoffService do
  let(:project) { instance_double(Project, id: 17) }
  let(:idempotency_key) { "projection-17" }

  before do
    allow(AgenticPpm::ProjectionRecord).to receive(:where).and_return(relation)
    allow(AgenticPpm::ProjectionRecord).to receive(:upsert)
  end

  let(:relation) do
    instance_double(ActiveRecord::Relation,
                    order: instance_double(ActiveRecord::Relation,
                                           limit: []))
  end

  it "does not call the remote runtime when the guarded configuration is absent" do
    stub_const("ENV", ENV.to_h.except("AGENTIC_PPM_AGENT_RUNTIME_BASE_URL", "AGENTIC_PPM_AGENT_RUNTIME_KEY"))

    result = described_class.new(project:, idempotency_key:).call

    expect(result).to include("accepted" => false, "reason" => "agent_runtime_not_configured")
    expect(AgenticPpm::ProjectionRecord).to have_received(:upsert)
  end

  it "uses the receiver's protected X-Agent-Key contract" do
    source = described_class.instance_method(:call).source_location.first
    text = File.read(source)

    expect(text).to include('"X-Agent-Key" => ENV.fetch("AGENTIC_PPM_AGENT_RUNTIME_KEY")')
    expect(text).not_to include("X-OpenProject-Evidence-Key")
  end
end
