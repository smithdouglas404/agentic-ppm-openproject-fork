require "spec_helper"
require "yaml"

RSpec.describe "Agentic PPM data protection policy" do
  let(:policy) do
    YAML.safe_load_file(Rails.root.join("config/agentic_ppm/data_protection_policy.yml"), aliases: true)
  end

  it "requires protected transport and encrypted storage for all sensitive data classes" do
    expect(policy.dig("transport", "external_services", "require_tls")).to be(true)
    expect(policy.dig("at_rest", "native_records", "encryption_required")).to be(true)
    expect(policy.dig("at_rest", "graph_data", "encryption_required")).to be(true)
    expect(policy.dig("at_rest", "documents", "encryption_required")).to be(true)
    expect(policy.dig("at_rest", "memory", "encryption_required")).to be(true)
  end

  it "requires key references and prohibits raw keys in source and logs" do
    expect(policy.dig("key_management", "prohibit_raw_keys_in_repository")).to be(true)
    expect(policy.dig("key_management", "prohibit_raw_keys_in_logs")).to be(true)
    expect(policy.dig("key_management", "rotation_required")).to be(true)
    expect(policy.dig("provenance", "record_key_reference")).to be(true)
  end
end
