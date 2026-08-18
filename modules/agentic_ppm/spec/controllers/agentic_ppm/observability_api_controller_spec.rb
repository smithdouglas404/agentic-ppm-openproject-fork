require "spec_helper"

RSpec.describe AgenticPpm::ObservabilityApiController, type: :controller do
  it "uses project permission and exposes trace, projection, sync, and capability posture" do
    source = File.read(Rails.root.join("modules/agentic_ppm/app/controllers/agentic_ppm/observability_api_controller.rb"))
    expect(source).to include("load_and_authorize_with_permission :view_agentic_ppm")
    expect(source).to include("AgenticPpm::ServiceRegistry.capability_states")
    expect(source).to include("latest_correlation_id")
    expect(source).to include("agent_run_status")
    expect(source).to include("sync_run_status")
  end
end
