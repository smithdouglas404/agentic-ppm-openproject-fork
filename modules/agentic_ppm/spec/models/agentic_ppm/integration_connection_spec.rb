require "spec_helper"

RSpec.describe AgenticPpm::IntegrationConnection do
  it "allows only the configured enterprise source providers" do
    expect(described_class::PROVIDERS).to contain_exactly("openproject", "jira", "servicenow", "dynatrace", "finops")
  end

  it "requires a protected credential reference before an integration can be enabled" do
    connection = described_class.new(provider: "jira", name: "Portfolio Jira", enabled: true)

    expect(connection).to be_invalid
    expect(connection.errors.of_kind?(:credential_reference, :exclusion)).to be(true)
  end
end
