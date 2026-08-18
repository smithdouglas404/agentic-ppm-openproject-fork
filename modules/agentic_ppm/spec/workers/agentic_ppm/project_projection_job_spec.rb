require "spec_helper"

RSpec.describe AgenticPpm::ProjectProjectionJob do
  let(:project) { instance_double(Project, id: 42) }
  let(:idempotency_key) { "projection-42-v1" }
  let(:projection_relation) { instance_double(ActiveRecord::Relation) }

  before do
    allow(Project).to receive(:find).with(42).and_return(project)
    allow(project).to receive(:module_enabled?).with(:agentic_ppm).and_return(true)
    allow(AgenticPpm::Ontology::ProjectProjectionService).to receive(:new).and_return(instance_double(AgenticPpm::Ontology::ProjectProjectionService, call: true))
    allow(AgenticPpm::Ontology::WorkPackageProjectionService).to receive(:new).and_return(instance_double(AgenticPpm::Ontology::WorkPackageProjectionService, call: true))
    allow(AgenticPpm::Ontology::WorkPackageRelationProjectionService).to receive(:new).and_return(instance_double(AgenticPpm::Ontology::WorkPackageRelationProjectionService, call: true))
    allow(AgenticPpm::Agents::OpenprojectEvidenceHandoffService).to receive(:new).and_return(instance_double(AgenticPpm::Agents::OpenprojectEvidenceHandoffService, call: { "accepted" => false }))
  end

  it "marks records for the idempotency key as projected after every source projection succeeds" do
    allow(AgenticPpm::ProjectionRecord).to receive(:where).with(project:, idempotency_key:).and_return(projection_relation)
    expect(projection_relation).to receive(:update_all).with(hash_including(projection_state: "projected"))

    described_class.new.perform(42, idempotency_key:)
  end

  it "persists bounded failure provenance for a known project and re-raises the source failure" do
    allow(AgenticPpm::Ontology::ProjectProjectionService).to receive(:new).and_raise(StandardError, "source projection failed")
    expect(AgenticPpm::ProjectionRecord).to receive(:upsert).with(
      hash_including(
        project_id: 42,
        entity_key: "openproject:projection_failure:42",
        projection_state: "failed",
        idempotency_key:,
        payload: hash_including(error_class: "StandardError", error_message: "source projection failed")
      ),
      unique_by: :index_agentic_ppm_projection_entity_identity
    )

    expect { described_class.new.perform(42, idempotency_key:) }.to raise_error(StandardError, "source projection failed")
  end
end
