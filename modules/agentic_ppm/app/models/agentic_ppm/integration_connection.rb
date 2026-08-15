module AgenticPpm
  class IntegrationConnection < ApplicationRecord
    PROVIDERS = %w[openproject jira servicenow dynatrace finops].freeze

    self.table_name = "agentic_ppm_integration_connections"

    belongs_to :project
    has_many :sync_runs, class_name: "AgenticPpm::SyncRun", dependent: :destroy

    validates :provider, inclusion: { in: PROVIDERS }
    validates :name, presence: true
    validates :credential_reference, exclusion: { in: [nil, ""] }, if: :enabled?
  end
end
