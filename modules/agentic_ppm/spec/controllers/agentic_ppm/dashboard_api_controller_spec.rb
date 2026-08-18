require "spec_helper"

RSpec.describe AgenticPpm::DashboardApiController do
  let(:permissions) { %i[view_agentic_ppm] }
  let(:project_role) { create(:project_role, permissions:, add_public_permissions: false) }
  let(:project) { create(:project, enabled_module_names: ["agentic_ppm"]) }
  let(:user) { create(:user, member_with_roles: { project => project_role }) }
  let(:dashboard_evidence) do
    {
      projection_summary: {}, relationship_types: ["follows"], selected_relationship_type: "follows", relationship_evidence: [],
      entity_options: [], selected_entity_key: nil, inspected_entity: nil, inspection_attributes: {},
      source_review_signals: [], source_review_signal_options: [], selected_source_review_signal: nil,
      source_review_signal_details: nil, scheduled_work_packages: []
    }
  end

  before do
    login_as(user)
    allow(AgenticPpm::DashboardEvidenceService).to receive(:new).and_return(double(call: dashboard_evidence))
    allow(AgenticPpm::AgentRun).to receive(:where).and_return([])
  end

  it "returns the native project-scoped dashboard contract as JSON" do
    get :show,
        params: {
          project_id: project.id,
          relationship_type: "follows",
          entity_key: "openproject:work_package:6"
        },
        as: :json

    expect(response).to be_successful
    expect(response.parsed_body).to include(
      "project" => include("id" => project.id, "name" => project.name),
      "relationship_types" => ["follows"],
      "agent_runs" => []
    )
    expect(AgenticPpm::DashboardEvidenceService).to have_received(:new).with(
      project:,
      relationship_type: "follows",
      entity_key: "openproject:work_package:6",
      alert_key: nil
    )
  end

  it "forbids a project member without dashboard permission" do
    project_role.update!(permissions: %i[view_project])

    get :show, params: { project_id: project.id }, as: :json

    expect(response).to have_http_status(:forbidden)
  end
end
