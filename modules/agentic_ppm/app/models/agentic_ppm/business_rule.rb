module AgenticPpm
  class BusinessRule < ApplicationRecord
    CATEGORIES = %w[agent_routing alert approval retrieval integration].freeze

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
  end
end
