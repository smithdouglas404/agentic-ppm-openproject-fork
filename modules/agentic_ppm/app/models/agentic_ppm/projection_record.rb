module AgenticPpm
  class ProjectionRecord < ApplicationRecord
    self.table_name = "agentic_ppm_projection_records"

    belongs_to :project

    validates :source_type, :source_id, :entity_type, :entity_key, :projection_state, :idempotency_key, :observed_at, presence: true
    validates :entity_type, inclusion: { in: %w[project work_package actor relationship] }
    validates :projection_state, inclusion: { in: %w[pending projected failed] }
  end
end
