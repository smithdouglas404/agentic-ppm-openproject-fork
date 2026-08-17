require "spec_helper"
require "yaml"

RSpec.describe "Agentic PPM Memgraph projection contract" do
  let(:contract) do
    YAML.safe_load_file(Rails.root.join("config/agentic_ppm/memgraph_projection.yml"), aliases: true)
  end

  it "is inactive until explicitly authorized and healthy" do
    expect(contract.fetch("status")).to eq("requires_authorized_activation")
    expect(contract.dig("activation", "required_preconditions")).to include(
      "authorized_endpoint", "protected_credential", "health_check_passed", "project_scope_authorized"
    )
    expect(contract.dig("health_check", "failure_behavior")).to eq("disable_adapter_and_record_non_secret_error")
  end

  it "requires provenance, server-side project scope, and compensating rollback" do
    expect(contract.dig("projection", "required_fact_envelope")).to include(
      "entity_key", "source_record", "mapping_profile", "authorization_provenance", "correlation_id"
    )
    expect(contract.dig("query_authorization", "browser_direct_access")).to eq("prohibited")
    expect(contract.dig("rollback", "strategy")).to eq("projection_run_scoped_compensating_delete")
    expect(contract.dig("rollback", "never_delete")).to include("openproject_source_records", "external_source_records")
  end
end
