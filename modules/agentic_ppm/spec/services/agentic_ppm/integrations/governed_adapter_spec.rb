require "spec_helper"

RSpec.describe "Agentic PPM governed read-only adapters" do
  let(:project) { instance_double(Project) }
  let(:sync_run) { double(state_requested?: false) }

  def connection_for(configuration:)
    double(
      project: project,
      project_id: 7,
      configuration: configuration,
      enabled?: false,
      credential_reference: nil
    )
  end

  it "creates an unavailable Jira read-only request only after policy validation" do
    configuration = {
      "endpoint_url" => "https://example.atlassian.net",
      "mapping_profile" => "jira_issue_epic_sprint_release_dependency_v1"
    }
    adapter = AgenticPpm::Integrations::JiraAdapter.new(connection: connection_for(configuration:))
    allow(AgenticPpm::SyncRun).to receive(:create!).and_return(sync_run)

    result = adapter.sync(mode: "read_only", correlation_id: "jira-proof")

    expect(result).to eq(sync_run)
    expect(AgenticPpm::SyncRun).to have_received(:create!).with(hash_including(mode: "read_only", state: "unavailable", correlation_id: "jira-proof"))
  end

  it "rejects an unapproved Jira mode before creating a sync run" do
    configuration = {
      "endpoint_url" => "https://example.atlassian.net",
      "mapping_profile" => "jira_issue_epic_sprint_release_dependency_v1"
    }
    adapter = AgenticPpm::Integrations::JiraAdapter.new(connection: connection_for(configuration:))
    expect(AgenticPpm::SyncRun).not_to receive(:create!)

    expect { adapter.sync(mode: "write", correlation_id: "jira-write") }
      .to raise_error(AgenticPpm::Integrations::BaseAdapter::PolicyViolation, "sync mode is not approved")
  end

  it "rejects ServiceNow insecure endpoints and unapproved mapping profiles before creating a sync run" do
    configuration = {
      "endpoint_url" => "http://user:password@example.service-now.com",
      "mapping_profile" => "unapproved_profile"
    }
    adapter = AgenticPpm::Integrations::ServiceNowAdapter.new(connection: connection_for(configuration:))
    expect(AgenticPpm::SyncRun).not_to receive(:create!)

    expect { adapter.sync(mode: "read_only", correlation_id: "servicenow-proof") }
      .to raise_error(AgenticPpm::Integrations::BaseAdapter::PolicyViolation, "mapping profile is not approved")
  end
end
