module AgenticPpm
  class ProjectionRecord < ApplicationRecord
    self.table_name = "agentic_ppm_projection_records"

    belongs_to :project

    before_validation :apply_provenance_defaults

    validates :source_type, :source_id, :entity_type, :entity_key, :projection_state, :idempotency_key, :observed_at, presence: true
    validates :ontology_version, :mapping_profile, :authorization_provenance, :confidence, :correlation_id, presence: true
    validates :confidence, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
    validates :entity_type, inclusion: { in: %w[project work_package actor relationship] }
    validates :projection_state, inclusion: { in: %w[pending projected failed] }

    private

    def apply_provenance_defaults
      self.ontology_version ||= "1"
      self.mapping_profile ||= "openproject-native-v1"
      self.authorization_provenance ||= "openproject-project-scope"
      self.confidence ||= 1.0
      self.correlation_id ||= idempotency_key
    end
  end
end
