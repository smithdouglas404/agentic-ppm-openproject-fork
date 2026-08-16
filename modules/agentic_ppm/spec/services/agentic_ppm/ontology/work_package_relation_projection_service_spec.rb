require "spec_helper"

RSpec.describe AgenticPpm::Ontology::WorkPackageRelationProjectionService do
  it "projects a native follows relation with source-backed work-package identities" do
    project = instance_double(Project, id: 42)
    work_packages = double
    relation_scope = double
    relation = instance_double(Relation, id: 33, from_id: 21, to_id: 22, relation_type: "follows")
    allow(project).to receive(:work_packages).and_return(work_packages)
    allow(work_packages).to receive(:pluck).with(:id).and_return([21, 22])
    allow(Relation).to receive(:where).with(from_id: [21, 22], to_id: [21, 22]).and_return(relation_scope)
    allow(relation_scope).to receive(:find_each).and_yield(relation)
    allow(AgenticPpm::ProjectionRecord).to receive(:upsert)

    described_class.new(project:, idempotency_key: "project-42-v3").call

    expect(AgenticPpm::ProjectionRecord).to have_received(:upsert).with(
      hash_including(
        entity_type: "relationship",
        entity_key: "openproject:relationship:follows:21:22",
        payload: {
          relationship_type: "follows",
          from_key: "openproject:work_package:21",
          to_key: "openproject:work_package:22"
        }
      ),
      unique_by: :index_agentic_ppm_projection_entity_identity
    )
  end
end
