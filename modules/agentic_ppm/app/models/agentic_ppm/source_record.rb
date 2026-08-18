module AgenticPpm
  class SourceRecord < ApplicationRecord
    self.table_name = "agentic_ppm_source_records"

    SOURCE_TYPES = %w[document excel jira servicenow dynatrace finops].freeze
    STATES = %w[staged approved projected rejected].freeze

    belongs_to :project
    belongs_to :created_by, class_name: "User"

    validates :source_type, inclusion: { in: SOURCE_TYPES }
    validates :source_id, :filename, :content_type, :content_sha256, :storage_key, presence: true
    validates :byte_size, numericality: { greater_than_or_equal_to: 0 }
    validates :version, numericality: { only_integer: true, greater_than: 0 }
    validates :state, inclusion: { in: STATES }
    validate :provenance_contains_project_scope

    private

    def provenance_contains_project_scope
      return if provenance.to_h["project_id"].to_i == project_id.to_i

      errors.add(:provenance, "must include the owning project scope")
    end
  end
end
