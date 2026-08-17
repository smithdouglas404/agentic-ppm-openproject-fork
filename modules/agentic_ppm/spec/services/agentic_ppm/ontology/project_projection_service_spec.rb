require "spec_helper"

RSpec.describe AgenticPpm::Ontology::ProjectProjectionService do
  let(:project) { build_stubbed(:project, id: 42, identifier: "hybrid-transformation", name: "Hybrid Transformation") }

  it "uses a stable OpenProject project entity identity" do
    work_packages = double
    allow(project).to receive(:work_packages).and_return(work_packages)
    allow(work_packages).to receive(:includes).with(:type).and_return([])

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

  it "projects concurrent waterfall, scaled Agile, and hybrid evidence from configured work-package types" do
    waterfall_milestone = double(id: 21, type: double(name: "Milestone"))
    scaled_agile_sprint = double(id: 22, type: double(name: "Sprint"))
    work_packages = double
    allow(project).to receive(:work_packages).and_return(work_packages)
    allow(work_packages).to receive(:includes).with(:type).and_return([waterfall_milestone, scaled_agile_sprint])

    payload = described_class.new(project:, idempotency_key: "project-42-v2").send(:projection_attributes).fetch(:payload)

    expect(payload.dig(:delivery_method_evidence, "candidate_methods")).to contain_exactly(
      "waterfall", "scaled_agile", "hybrid"
    )
    expect(payload.dig(:delivery_method_evidence, "evidence", "waterfall", "matched_work_packages")).to include(
      { "work_package_id" => 21, "type" => "Milestone" }
    )
    expect(payload.dig(:delivery_method_evidence, "evidence", "scaled_agile", "matched_work_packages")).to include(
      { "work_package_id" => 22, "type" => "Sprint" }
    )
  end
end
