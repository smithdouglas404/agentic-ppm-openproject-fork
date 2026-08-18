require "spec_helper"

RSpec.describe AgenticPpm::Finding do
  it "requires evidence before approval and keeps the AgentRun project-scoped" do
    source = File.read(Rails.root.join("modules/agentic_ppm/app/models/agentic_ppm/finding.rb"))
    expect(source).to include("agent_run_belongs_to_project")
    expect(source).to include("approved_findings_require_evidence")
    expect(source).to include('STATUSES = %w[proposed approved rejected escalated needs_evidence]')
    expect(source).to include("def review!(status:, reviewer:, note: nil)")
  end
end
