module AgenticPpm
  class Finding < ApplicationRecord
    self.table_name = "agentic_ppm_findings"

    belongs_to :project
    belongs_to :agent_run
    belongs_to :created_by, class_name: "User"
    belongs_to :reviewed_by, class_name: "User", optional: true

    STATUSES = %w[proposed approved rejected escalated needs_evidence].freeze
    SEVERITIES = %w[low medium high critical].freeze

    validates :finding_type, :narrative, :status, presence: true
    validates :status, inclusion: { in: STATUSES }
    validates :severity, inclusion: { in: SEVERITIES }
    validates :confidence, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }, allow_nil: true
    validate :agent_run_belongs_to_project
    validate :approved_findings_require_evidence

    def review!(status:, reviewer:, note: nil)
      raise ArgumentError, "unsupported finding status" unless STATUSES.include?(status.to_s)
      raise ArgumentError, "reviewer is required" unless reviewer

      update!(
        status: status,
        reviewed_by: reviewer,
        reviewed_at: Time.current,
        review_note: note
      )
    end

    private

    def agent_run_belongs_to_project
      return unless project && agent_run
      return if agent_run.project_id == project_id

      errors.add(:agent_run, "must belong to the same project")
    end

    def approved_findings_require_evidence
      return unless status == "approved"
      return if evidence_references.is_a?(Array) && evidence_references.any?

      errors.add(:evidence_references, "are required before approval")
    end
  end
end
