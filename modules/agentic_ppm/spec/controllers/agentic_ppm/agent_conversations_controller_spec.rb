require "spec_helper"

RSpec.describe AgenticPpm::AgentConversationsController do
  let(:permissions) { %i[run_agentic_ppm_agents] }
  let(:project_role) { create(:project_role, permissions:, add_public_permissions: false) }
  let(:project) { create(:project, enabled_module_names: ["agentic_ppm"]) }
  let(:user) { create(:user, member_with_roles: { project => project_role }) }
  let(:contracts) do
    [
      { "invocation_key" => "PMO", "name" => "PMO Agent", "responsibility" => "Delivery oversight", "escalation" => "PMO owner", "permitted_tools" => "read_project_evidence" },
      { "invocation_key" => "VRO", "name" => "VRO Agent", "responsibility" => "Value evidence", "escalation" => "VRO owner", "permitted_tools" => "read_value_evidence" }
    ]
  end

  before do
    login_as(user)
    allow(AgenticPpm::ServiceRegistry).to receive(:specialist_contracts).and_return(contracts)
    allow(AgenticPpm::ServiceRegistry).to receive(:adapter_for).with(:letta).and_return(double(capability_state: :disabled))
  end

  it "renders the PMO/VRO workspace with an explicit unavailable runtime boundary" do
    get :show, params: { project_id: project.id }

    expect(response).to be_successful
    expect(response).to render_template(:show)
  end

  it "forbids a project member without the agent-run permission" do
    project_role.update!(permissions: %i[view_project])

    get :show, params: { project_id: project.id }

    expect(response).to have_http_status(:forbidden)
  end
end
