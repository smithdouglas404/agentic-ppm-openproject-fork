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
end
