require "spec_helper"

RSpec.describe AgenticPpm::Ontology::ProjectProjectionService do
  let(:project) { build_stubbed(:project, id: 42, identifier: "hybrid-transformation", name: "Hybrid Transformation") }

  it "uses a stable OpenProject project entity identity" do
    service = described_class.new(project:, idempotency_key: "project-42-v1")

    attributes = service.send(:projection_attributes)

    expect(attributes).to include(
      project_id: 42,
      source_type: "openproject",
      source_id: 42,
      entity_type: "project",
      entity_key: "openproject:project:42",
      projection_state: "pending"
    )
  end
end
