require "spec_helper"

RSpec.describe AgenticPpm::Ontology::ValidationService do
  describe "project payloads" do
    it "accepts mapped fields and retains ontology metadata" do
      result = described_class.new(
        entity_type: "project",
        ontology_version: "1.1.0",
        mapping_profile: "customer-profile-v2",
        required_fields: %w[identifier name],
        payload: {
          identifier: "P-001",
          name: "Transformation pilot",
          active: true
        }
      ).call

      expect(result).to include(
        valid: true,
        ontology_version: "1.1.0",
        mapping_profile: "customer-profile-v2",
        unmapped_fields: [],
        missing_required_fields: []
      )
    end

    it "reports unmapped and missing required fields without discarding the payload" do
      result = described_class.new(
        entity_type: "project",
        required_fields: %w[identifier name],
        payload: { identifier: "P-002", unrecognized: "retain-as-evidence" }
      ).call

      expect(result[:valid]).to be(false)
      expect(result[:unmapped_fields]).to eq(["unrecognized"])
      expect(result[:missing_required_fields]).to eq(["name"])
    end
  end
end
