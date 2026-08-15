module AgenticPpm
  class AgentRun < ApplicationRecord
    self.table_name = "agentic_ppm_agent_runs"

    belongs_to :project
    belongs_to :user

    validates :specialist, inclusion: { in: %w[PMO VRO OKR/KPI OCM Governance FinOps TMO BusinessPlanning] }
    validates :prompt, :state, :correlation_id, presence: true
    validates :state, inclusion: { in: %w[requested completed unavailable failed] }

    def self.persisted_specialist_name(name)
      name == "Business Planning" ? "BusinessPlanning" : name
    end
  end
end
