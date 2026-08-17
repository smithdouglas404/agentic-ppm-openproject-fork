require "spec_helper"

RSpec.describe AgenticPpm::IntegrationConnection do
  let(:project) { build_stubbed(:project) }

  it "allows only the configured enterprise source providers" do
    expect(described_class::PROVIDERS).to contain_exactly("openproject", "jira", "servicenow", "dynatrace", "finops")
  end

  it "requires a protected credential reference before an integration can be enabled" do
    connection = described_class.new(provider: "jira", name: "Portfolio Jira", enabled: true)

    expect(connection).to be_invalid
    expect(connection.errors.of_kind?(:credential_reference, :exclusion)).to be(true)
  end

  it "accepts disabled Jira metadata only when it matches the approved HTTPS endpoint and mapping policy" do
    connection = described_class.new(
      project: project,
      provider: "jira",
      name: "Portfolio Jira",
      enabled: false,
      configuration: {
        "endpoint_url" => "https://example.atlassian.net",
        "mapping_profile" => "jira_issue_epic_sprint_release_dependency_v1",
        "authentication_mode" => "oauth_2_3lo",
        "policy_version" => 1,
        "activation" => "disabled_by_default",
        "allowed_sync_modes" => ["read_only"],
        "required_provenance" => %w[source_id source_key authorizing_account project_scope requested_scopes mapping_profile observed_at correlation_id]
      }
    )

    expect(connection).to be_valid
  end

  it "rejects Jira metadata with an insecure endpoint or an unapproved mapping profile" do
    connection = described_class.new(
      project: project,
      provider: "jira",
      name: "Unsafe Jira",
      enabled: false,
      configuration: {
        "endpoint_url" => "http://user:password@example.atlassian.net",
        "mapping_profile" => "unreviewed_mapping",
        "authentication_mode" => "oauth_2_3lo",
        "policy_version" => 1,
        "activation" => "disabled_by_default",
        "allowed_sync_modes" => ["read_only"],
        "required_provenance" => %w[source_id source_key authorizing_account project_scope requested_scopes mapping_profile observed_at correlation_id]
      }
    )

    expect(connection).to be_invalid
    expect(connection.errors[:configuration]).to include("requires an HTTPS endpoint URL without embedded credentials", "uses an unapproved mapping profile")
  end
end
