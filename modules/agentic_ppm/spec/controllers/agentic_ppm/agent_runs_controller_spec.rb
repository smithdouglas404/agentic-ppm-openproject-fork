require "spec_helper"

RSpec.describe AgenticPpm::AgentRunsController do
  let(:permissions) { %i[run_agentic_ppm_agents] }
  let(:project_role) { create(:project_role, permissions:, add_public_permissions: false) }
  let(:project) { create(:project, enabled_module_names: ["agentic_ppm"]) }
  let(:user) { create(:user, member_with_roles: { project => project_role }) }
  let(:run) do
    instance_double(
      AgenticPpm::AgentRun,
      id: 7,
      project_id: project.id,
      specialist: "PMO",
      state: "unavailable",
      correlation_id: "corr-7",
      prompt: "Review risk",
      response: nil,
      evidence_references: [],
      created_at: Time.utc(2026, 8, 17),
      updated_at: Time.utc(2026, 8, 17)
    )
  end
  let(:result) { double(available: false, run:) }

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

  it "returns the native AgentRun contract as JSON for the retained agent UI" do
    post :create,
         params: {
           project_id: project.id,
           specialist: "PMO",
           prompt: "Review risk"
         },
         as: :json

    expect(response).to have_http_status(:service_unavailable)
    expect(response.parsed_body).to include(
      "available" => false,
      "agent_run" => include("id" => 7, "project_id" => project.id, "specialist" => "PMO")
    )
  end

  it "forbids a project member without the agent-run permission" do
    project_role.update!(permissions: %i[view_project])

    post :create, params: { project_id: project.id, specialist: "PMO", prompt: "Review risk" }

    expect(response).to have_http_status(:forbidden)
  end

  it "defines project-scoped list and detail contracts with trace fields" do
    source = File.read(Rails.root.join("modules/agentic_ppm/app/controllers/agentic_ppm/agent_runs_controller.rb"))
    expect(source).to include("AgenticPpm::AgentRun.where(project: @project)")
    expect(source).to include("params[:idempotency_key].presence")
    expect(source).to include("correlation_id:")
    expect(source).to include("trace_references:")
    expect(source).to include("memory_trace:")
    expect(source).to include("graph_evidence:")
    expect(source).to include('code: "not_found"')
  end
end
