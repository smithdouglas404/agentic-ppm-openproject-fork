require "spec_helper"

RSpec.describe AgenticPpm::Integrations::MappingProfileService do
  it "maps Jira issue metadata only through its approved profile and field allow-list" do
    result = described_class.new(
      provider: "jira",
      mapping_profile: "jira_issue_epic_sprint_release_dependency_v1"
    ).map(
      source_entity: "issue",
      metadata: { key: "PPM-42", summary: "Delivery risk", issuelinks: ["PPM-41"], priority: "high" }
    )

    expect(result).to include(
      "provider" => "jira",
      "source_entity" => "issue",
      "ontology_target" => "work_package",
      "mapping_profile" => "jira_issue_epic_sprint_release_dependency_v1"
    )
    expect(result.fetch("attributes")).to include("key" => "PPM-42", "summary" => "Delivery risk", "issuelinks" => ["PPM-41"])
    expect(result.fetch("attributes")).not_to have_key("priority")
  end

  it "maps ServiceNow change metadata only through its approved profile and allow-list" do
    result = described_class.new(
      provider: "servicenow",
      mapping_profile: "servicenow_demand_change_incident_service_risk_v1"
    ).map(
      source_entity: "change_request",
      metadata: { number: "CHG001", short_description: "Release window", risk: "high", requested_by: "unapproved" }
    )

    expect(result).to include("ontology_target" => "change", "mapping_profile" => "servicenow_demand_change_incident_service_risk_v1")
    expect(result.fetch("attributes")).to include("number" => "CHG001", "short_description" => "Release window", "risk" => "high")
    expect(result.fetch("attributes")).not_to have_key("requested_by")
  end

  it "rejects unapproved mapping profiles and unsupported source entities" do
    service = described_class.new(provider: "jira", mapping_profile: "unapproved")
    expect { service.map(source_entity: "issue", metadata: {}) }.to raise_error(described_class::InvalidMappingProfile)

    service = described_class.new(provider: "jira", mapping_profile: "jira_issue_epic_sprint_release_dependency_v1")
    expect { service.map(source_entity: "user", metadata: {}) }.to raise_error(described_class::UnsupportedSourceEntity)
  end
end
