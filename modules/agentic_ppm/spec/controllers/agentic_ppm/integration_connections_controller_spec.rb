require "spec_helper"

RSpec.describe AgenticPpm::IntegrationConnectionsController do
  it "keeps the connector inventory project-scoped and redacts secrets" do
    source = File.read(Rails.root.join("modules/agentic_ppm/app/controllers/agentic_ppm/integration_connections_controller.rb"))
    expect(source).to include("load_and_authorize_with_permission_in_project :manage_agentic_ppm_integrations")
    expect(source).to include("IntegrationConnection.where(project: @project)")
    expect(source).to include('"credential", "token", "api_key", "client_secret"')
    expect(source).to include('"disabled"')
    expect(source).to include('"degraded"')
    expect(source).to include('"configured"')
  end
end
