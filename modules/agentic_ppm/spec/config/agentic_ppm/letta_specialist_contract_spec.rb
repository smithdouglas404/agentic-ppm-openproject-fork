require "spec_helper"
require "yaml"

RSpec.describe "Agentic PPM Letta specialist contract" do
  let(:contract) do
    YAML.safe_load_file(Rails.root.join("config/agentic_ppm/agents.yml"), aliases: true)
  end

  it "defines deterministic identities, scoped conversations, project permission enforcement, and required traces" do
    letta = contract.fetch("letta_contract")

    expect(letta).to include(
      "activation" => "requires_authorized_service_and_credentials",
      "identity_template" => "agentic_ppm/%{invocation_key}",
      "conversation_scope" => "project_and_authorized_user",
      "project_permission_requirement" => "view_agentic_ppm_and_run_agentic_ppm_agents"
    )
    expect(letta.fetch("trace_requirements")).to include(
      "openproject_user_id", "project_id", "authorization_decision", "evidence_references"
    )
  end

  it "gives each exact specialist an identity template while prohibiting ungoverned writes and unscoped memory" do
    agents = contract.fetch("agents")

    expect(agents.map { |agent| agent.fetch("letta_template") }).to contain_exactly(
      "agentic_ppm/PMO", "agentic_ppm/VRO", "agentic_ppm/OKR_KPI", "agentic_ppm/OCM",
      "agentic_ppm/GOVERNANCE", "agentic_ppm/FINOPS", "agentic_ppm/TMO", "agentic_ppm/BUSINESS_PLANNING"
    )
    expect(contract.dig("letta_contract", "prohibited_capabilities")).to include(
      "direct_openproject_write_without_governed_workflow", "unscoped_memory_retrieval"
    )
  end
end
