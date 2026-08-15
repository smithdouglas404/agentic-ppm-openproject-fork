require "spec_helper"

RSpec.describe AgenticPpm::IntegrationConnection do
  it "allows only the configured enterprise source providers" do
    expect(described_class::PROVIDERS).to contain_exactly("openproject", "jira", "servicenow", "dynatrace", "finops")
  end
end
