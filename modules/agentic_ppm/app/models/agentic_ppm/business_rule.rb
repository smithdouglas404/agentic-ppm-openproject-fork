module AgenticPpm
  class BusinessRule < ApplicationRecord
    CATEGORIES = %w[agent_routing alert approval retrieval integration governance].freeze

    self.table_name = "agentic_ppm_business_rules"

    belongs_to :project
    belongs_to :created_by, class_name: "User"
    belongs_to :approved_by, class_name: "User", optional: true

    enum :state, {
      draft: "draft",
      submitted: "submitted",
      approved: "approved",
      published: "published",
      rolled_back: "rolled_back",
      archived: "archived"
    }, prefix: true

    validates :name, :category, :state, presence: true
    validates :category, inclusion: { in: CATEGORIES }
    validates :visual_flow_reference, presence: true, if: :state_published?
    validate :published_evidence_contract

    before_validation :normalize_evidence

    private

    def normalize_evidence
      self.validation_result = validation_result.to_h
      self.simulation_trace = simulation_trace.to_h
      self.authorization_decision = authorization_decision.to_h
    end

    def published_evidence_contract
      return unless state_published?

      required_validation_fields = %w[valid flow_reference flow_version validated_at validator_identity policy_version]
      missing_validation_fields = required_validation_fields.reject { |field| validation_result[field].present? }
      errors.add(:validation_result, "is incomplete for publication") if validation_result["valid"] != true || missing_validation_fields.any?
      errors.add(:simulation_trace, "must contain a valid trace for publication") unless simulation_trace["valid"] == true && simulation_trace["trace_id"].present?
      errors.add(:authorization_decision, "is required for publication") unless authorization_decision["authorized"] == true && authorization_decision["rule_id"].present?
    end
  end
end
