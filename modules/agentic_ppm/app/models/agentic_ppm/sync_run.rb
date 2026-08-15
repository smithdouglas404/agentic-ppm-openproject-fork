module AgenticPpm
  class SyncRun < ApplicationRecord
    self.table_name = "agentic_ppm_sync_runs"

    belongs_to :integration_connection, class_name: "AgenticPpm::IntegrationConnection"
    belongs_to :project

    enum :state, {
      requested: "requested",
      running: "running",
      completed: "completed",
      unavailable: "unavailable",
      failed: "failed"
    }, prefix: true

    validates :mode, inclusion: { in: %w[manual scheduled webhook] }
    validates :state, inclusion: { in: %w[requested running completed unavailable failed] }
    validates :correlation_id, presence: true, uniqueness: true
  end
end
