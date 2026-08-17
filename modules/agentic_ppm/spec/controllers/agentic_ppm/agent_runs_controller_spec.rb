require "spec_helper"

RSpec.describe AgenticPpm::AgentRunsController do
  let(:permissions) { %i[run_agentic_ppm_agents] }
  let(:project_role) { create(:project_role, permissions:, add_public_permissions: false) }
  let(:project) { create(:project, enabled_module_names: ["agentic_ppm"]) }
  let(:user) { create(:user, member_with_roles: { project => project_role }) }
  let(:result) { double(available: false) }

  before do
    login_as(user)
    allow(AgenticPpm::Agents::InvocationService).to receive(:new).and_return(double(call: result))
  end

  it "records an invocation through the governed service and safely returns to conversations" do
    post :create,
         params: {
           project_id: project.id,
           specialist: "PMO",
           prompt: "Which delivery risks need review?",
           return_to: "conversations"
         }

    expect(AgenticPpm::Agents::InvocationService).to have_received(:new).with(
      project: project,
      user: user,
      specialist: "PMO",
      prompt: "Which delivery risks need review?"
    )
    expect(response).to redirect_to(project_agentic_ppm_conversations_path(project))
    expect(flash[:notice]).to eq(I18n.t(:agentic_ppm_agent_runtime_unavailable))
  end

  it "forbids a project member without the agent-run permission" do
    project_role.update!(permissions: %i[view_project])

    post :create, params: { project_id: project.id, specialist: "PMO", prompt: "Review risk" }

    expect(response).to have_http_status(:forbidden)
  end
end
