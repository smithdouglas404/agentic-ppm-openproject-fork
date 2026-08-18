require "spec_helper"
require "yaml"

RSpec.describe "Agentic PPM canonical ontology contract" do
  let(:contract) do
    YAML.safe_load_file(Rails.root.join("config/agentic_ppm/ontology.yml"), aliases: true)
  end

  it "defines the required canonical entity vocabulary and marks unsupported projections as planned" do
    entity_types = contract.fetch("canonical_entity_types")
    names = entity_types.map { |entry| entry.fetch("entity_type") }

    expect(names).to include(
      "project", "work_package", "milestone", "person", "risk", "decision",
      "objective", "kpi", "cost", "service", "change"
    )
    expect(entity_types.find { |entry| entry.fetch("entity_type") == "project" }).to include(
      "current_projection" => "supported"
    )
    expect(entity_types.find { |entry| entry.fetch("entity_type") == "risk" }).to include(
      "current_projection" => "planned"
    )
  end

  it "defines canonical relationship vocabulary and the mandatory provenance envelope" do
    relationship_names = contract.fetch("canonical_relationship_types").map { |entry| entry.fetch("relationship_type") }

    expect(relationship_names).to include(
      "contains", "depends_on", "assigned_to", "governed_by",
      "contributes_to", "funds", "impacts", "mitigates"
    )
    expect(contract.fetch("fact_provenance").fetch("required_attributes")).to contain_exactly(
      "confidence", "observed_at", "source_system", "source_record",
      "mapping_profile", "authorization_provenance"
    )
  end

  it "writes the required provenance envelope from every native projection service" do
    projection_files = %w[
      project_projection_service.rb
      work_package_projection_service.rb
      work_package_relation_projection_service.rb
    ].map { |name| Rails.root.join("modules/agentic_ppm/app/services/agentic_ppm/ontology", name) }

    projection_files.each do |path|
      source = File.read(path)
      expect(source).to include('ontology_version: "1"')
      expect(source).to include('mapping_profile: "openproject-native-v1"')
      expect(source).to include('authorization_provenance: "openproject-project-scope"')
      expect(source).to include("confidence: 1.0")
      expect(source).to include("correlation_id: idempotency_key")
    end
  end
end
