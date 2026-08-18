require "spec_helper"
require "yaml"

RSpec.describe "Agentic PPM security policy" do
  let(:policy) do
    YAML.safe_load_file(Rails.root.join("config/agentic_ppm/security_policy.yml"), aliases: true)
  end

  it "prohibits raw secret persistence and logging" do
    expect(policy.dig("secret_handling", "storage_mode")).to eq("credential_reference_only")
    expect(policy.dig("secret_handling", "prohibited_persistence")).to include("raw_api_keys", "passwords", "session_tokens")
    expect(policy.dig("secret_handling", "prohibited_logging")).to include("authorization_values", "decrypted_secret_values")
  end

  it "requires scoped fail-closed access, TLS, and rotation evidence" do
    expect(policy.dig("secret_handling", "access", "require_project_scope")).to be(true)
    expect(policy.dig("secret_handling", "access", "fail_closed_when_reference_missing")).to be(true)
    expect(policy.dig("secret_handling", "rotation", "required")).to be(true)
    expect(policy.dig("transport", "require_tls_for_external_services")).to be(true)
  end
end
