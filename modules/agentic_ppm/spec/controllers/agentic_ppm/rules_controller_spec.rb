require "spec_helper"

RSpec.describe AgenticPpm::RulesController do
  let(:permissions) { %i[manage_agentic_ppm_rules] }
  let(:project_role) { create(:project_role, permissions:, add_public_permissions: false) }
  let(:project) { create(:project, enabled_module_names: ["agentic_ppm"]) }
  let(:user) { create(:user, member_with_roles: { project => project_role }) }
  let(:rule) do
    project.business_rules.create!(
      name: "Require evidence",
      category: "governance",
      state: "draft",
      created_by: user,
      visual_flow_reference: "langflow://governance-v1",
      definition: { "condition" => "missing_schedule" }
    )
  end
  let(:adapter) { instance_double(AgenticPpm::ServiceAdapters::LangflowAdapter) }

  before do
    login_as(user)
    allow(AgenticPpm::ServiceAdapters::LangflowAdapter).to receive(:new).and_return(adapter)
  end

  it "persists a project-scoped Langflow validation result" do
    allow(adapter).to receive(:validate_rule).and_return(
      "valid" => true,
      "flow_reference" => "langflow://governance-v1",
      "flow_version" => "1",
      "validated_at" => "2026-08-18T00:00:00Z",
      "validator_identity" => "langflow",
      "policy_version" => "1",
      "validation_result_reference" => "validation-1"
    )

    post :validate, params: { project_id: project.id, id: rule.id }

    expect(response).to redirect_to(agentic_ppm_rules_path(project))
    expect(rule.reload.validation_result).to include("valid" => true)
    expect(adapter).to have_received(:validate_rule).with(rule:, actor: user, project: project)
  end

  it "persists a simulation trace before publication is attempted" do
    allow(adapter).to receive(:simulate_rule).and_return(
      "valid" => true,
      "trace_id" => "simulation-1",
      "policy_version" => "1"
    )

    post :simulate, params: { project_id: project.id, id: rule.id }

    expect(response).to redirect_to(agentic_ppm_rules_path(project))
    expect(rule.reload.simulation_trace).to include("valid" => true, "trace_id" => "simulation-1")
    expect(adapter).to have_received(:simulate_rule).with(
      rule:, actor: user, project: project, source_data: { "project_id" => project.id, "rule_id" => rule.id }
    )
  end

  it "forbids a project member without rule-management permission" do
    project_role.update!(permissions: %i[view_project])

    post :validate, params: { project_id: project.id, id: rule.id }

    expect(response).to have_http_status(:forbidden)
  end
end
