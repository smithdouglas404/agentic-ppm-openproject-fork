require "spec_helper"

RSpec.describe AgenticPpm::Ontology::WorkPackageProjectionService do
  let(:project) { build_stubbed(:project, id: 42) }
  let(:actor) { instance_double(User, id: 8, name: "Portfolio Lead") }
  let(:work_package) do
    double(
      id: 21,
      subject: "Enable regional rollout",
      type_id: 3,
      type: double(name: "Phase"),
      status_id: 2,
      status: double(name: "In progress"),
      parent_id: 20,
      start_date: Date.new(2026, 8, 15),
      due_date: Date.new(2026, 9, 30),
      estimated_hours: 120,
      done_ratio: 40,
      assigned_to: actor
    )
  end

  it "captures work-package source evidence without inferring a delivery method from a project label" do
    work_packages = double
    allow(project).to receive(:work_packages).and_return(work_packages)
    allow(work_packages).to receive(:includes).with(:type, :status, :assigned_to).and_return(work_packages)
    allow(work_packages).to receive(:find_each).and_yield(work_package)
    allow(AgenticPpm::ProjectionRecord).to receive(:upsert)

    described_class.new(project:, idempotency_key: "project-42-v2").call

    expect(AgenticPpm::ProjectionRecord).to have_received(:upsert).with(
      hash_including(entity_type: "work_package", entity_key: "openproject:work_package:21"),
      unique_by: :index_agentic_ppm_projection_entity_identity
    )
  end
end
