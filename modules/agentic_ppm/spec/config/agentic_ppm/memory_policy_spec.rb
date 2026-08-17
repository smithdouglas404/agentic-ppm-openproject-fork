require "spec_helper"
require "yaml"

RSpec.describe "Agentic PPM Mem0 memory policy" do
  let(:policy) do
    YAML.safe_load_file(Rails.root.join("config/agentic_ppm/memory_policy.yml"), aliases: true)
  end

  it "requires project, user, agent, and authorization scopes for retrieval" do
    expect(policy.fetch("scope_dimensions")).to include(
      "workspace_id", "project_id", "openproject_user_id", "agent_invocation_key", "authorization_policy"
    )
    expect(policy.dig("retrieval_policy", "require_all_scope_dimensions")).to be(true)
    expect(policy.dig("retrieval_policy", "require_current_openproject_authorization")).to be(true)
  end

  it "prohibits secret and unsupported inference extraction while requiring citation and governed deletion" do
    expect(policy.dig("extraction_policy", "prohibit")).to include(
      "connector_credentials", "session_tokens", "unverified_agent_inference_as_fact"
    )
    expect(policy.dig("source_citation", "required_fields")).to include(
      "source_record_identity", "authorization_provenance", "memory_policy_version"
    )
    expect(policy.dig("retention_policy", "deletion_triggers")).to include(
      "user_deletion_request", "source_revocation", "project_access_revocation"
    )
  end

  it "defines the storage envelope, authorization-gated writes and updates, and non-retrievable deletion tombstones" do
    storage = policy.fetch("storage_contract")

    expect(storage.dig("record_shape", "required_fields")).to include(
      "memory_id", "project_id", "openproject_user_id", "source_citations", "record_version"
    )
    expect(storage.dig("write_semantics", "require_current_openproject_authorization")).to be(true)
    expect(storage.dig("update_semantics", "preserve_prior_record_version")).to be(true)
    expect(storage.dig("deletion_semantics", "backend_delete_required")).to be(true)
    expect(storage.dig("deletion_semantics", "prohibit_retrieval_after_tombstone")).to be(true)
  end
end
