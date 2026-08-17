require "spec_helper"

RSpec.describe AgenticPpm::ProjectDashboardController do
  render_views

  let(:permissions) { %i[view_agentic_ppm] }
  let(:project_role) { create(:project_role, permissions:, add_public_permissions: false) }
  let(:project) { create(:project, enabled_module_names: ["agentic_ppm"]) }
  let(:user) { create(:user, member_with_roles: { project => project_role }) }
  let(:dashboard_evidence) do
    {
      projection_summary: {}, relationship_types: ["follows"], selected_relationship_type: "follows", relationship_evidence: [],
      entity_options: [], selected_entity_key: "openproject:work_package:6", inspected_entity: nil, inspection_attributes: {},
      source_review_signals: [], source_review_signal_options: ["missing_schedule:3"], selected_source_review_signal: "missing_schedule:3",
      source_review_signal_details: nil, scheduled_work_packages: []
    }
  end

  before do
    login_as(user)
    allow(AgenticPpm::DashboardEvidenceService).to receive(:new).and_return(double(call: dashboard_evidence))
  end

  it "passes relationship, entity, and alert interaction parameters into the source-backed evidence service" do
    get :show,
        params: {
          project_id: project.id,
          relationship_type: "follows",
          entity_key: "openproject:work_package:6",
          alert_key: "missing_schedule:3"
        }

    expect(response).to be_successful
    expect(AgenticPpm::DashboardEvidenceService).to have_received(:new).with(
      project: project,
      relationship_type: "follows",
      entity_key: "openproject:work_package:6",
      alert_key: "missing_schedule:3"
    )
    expect(response.body).to include(I18n.t(:agentic_ppm_intelligence_eyebrow))
    expect(response.body).to include(I18n.t(:agentic_ppm_safe_next_actions))
  end

  it "forbids a project member without dashboard permission" do
    project_role.update!(permissions: %i[view_project])

    get :show, params: { project_id: project.id }

    expect(response).to have_http_status(:forbidden)
  end
end
