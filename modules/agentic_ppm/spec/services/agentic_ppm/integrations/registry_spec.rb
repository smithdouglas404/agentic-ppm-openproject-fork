require "spec_helper"

RSpec.describe AgenticPpm::Integrations::Registry do
  it "resolves a Jira adapter through the provider registry" do
    connection = instance_double(AgenticPpm::IntegrationConnection, provider: "jira")

    expect(described_class.adapter_for(connection)).to be_a(AgenticPpm::Integrations::JiraAdapter)
  end

  it "resolves a ServiceNow adapter through the provider registry" do
    connection = instance_double(AgenticPpm::IntegrationConnection, provider: "servicenow")

    expect(described_class.adapter_for(connection)).to be_a(AgenticPpm::Integrations::ServiceNowAdapter)
  end
end
