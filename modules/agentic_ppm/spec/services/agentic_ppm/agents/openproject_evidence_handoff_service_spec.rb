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

  it "serializes the OpenProject project ID as a string for the FastAPI evidence envelope" do
    http_client = instance_double(AgenticPpm::Integrations::HttpClient, post: { "accepted" => true })
    record = instance_double(
      AgenticPpm::ProjectionRecord,
      source_type: "openproject",
      source_id: "17",
      entity_type: "project",
      entity_key: "openproject:project:17",
      projection_state: "projected",
      observed_at: Time.utc(2026, 8, 18, 12, 0, 0),
      payload: { "name" => "Enterprise Transformation Portfolio Pilot" }
    )
    ordered_records = instance_double(ActiveRecord::Relation)
    limited_records = [record]

    stub_const("ENV", ENV.to_h.merge(
      "AGENTIC_PPM_AGENT_RUNTIME_BASE_URL" => "http://127.0.0.1:8011",
      "AGENTIC_PPM_AGENT_RUNTIME_KEY" => "test-agent-key"
    ))
    allow(AgenticPpm::ProjectionRecord).to receive(:where).with(
      project:, idempotency_key:, projection_state: "projected"
    ).and_return(ordered_records)
    allow(ordered_records).to receive(:order).with(:entity_key).and_return(ordered_records)
    allow(ordered_records).to receive(:limit).with(500).and_return(limited_records)
    allow(AgenticPpm::Integrations::HttpClient).to receive(:new).and_return(http_client)

    described_class.new(project:, idempotency_key:).call

    expect(http_client).to have_received(:post).with(
      "/api/openproject/evidence",
      payload: hash_including(project_id: "17", idempotency_key:),
      headers: { "X-Agent-Key" => "test-agent-key" }
    )
  end
end
