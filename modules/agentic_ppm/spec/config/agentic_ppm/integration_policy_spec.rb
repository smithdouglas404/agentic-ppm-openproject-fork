require "spec_helper"
require "yaml"

RSpec.describe "Agentic PPM integration policy" do
  let(:policy) do
    YAML.safe_load_file(Rails.root.join("config/agentic_ppm/integrations.yml"), aliases: true).fetch("providers")
  end

  %w[jira servicenow].each do |provider|
    it "keeps #{provider} disabled and read-only until authorized activation" do
      provider_policy = policy.fetch(provider)

      expect(provider_policy.fetch("activation")).to eq("disabled_by_default")
      expect(provider_policy.fetch("allowed_sync_modes")).to eq(["read_only"])
      expect(provider_policy.fetch("required_provenance")).to include("mapping_profile", "observed_at", "correlation_id")
      expect(provider_policy.fetch("prohibited_operations")).to include("browser_direct_credential_entry")
    end
  end

  it "limits Jira sources, fields, and scopes to the approved portfolio evidence surface" do
    jira = policy.fetch("jira")

    expect(jira.dig("authorization", "preferred_mode")).to eq("oauth_2_3lo")
    expect(jira.dig("authorization", "required_scopes")).to include("read:jira-work", "read:sprint:jira-software")
    expect(jira.dig("field_allow_lists", "issue")).to include("issuelinks", "fixVersions", "sprint")
    expect(jira.fetch("mapping_profiles")).to eq(["jira_issue_epic_sprint_release_dependency_v1"])
    expect(jira.fetch("prohibited_operations")).to include("issue_write", "scope_expansion")
  end

  it "limits ServiceNow to approved table, field, and role evidence" do
    servicenow = policy.fetch("servicenow")

    expect(servicenow.dig("authorization", "preferred_mode")).to eq("oauth_2_0")
    expect(servicenow.fetch("table_allow_list")).to include("incident", "change_request", "sn_risk_risk")
    expect(servicenow.dig("field_allow_lists", "common")).to include("sys_id", "sys_updated_on")
    expect(servicenow.fetch("mapping_profiles")).to eq(["servicenow_demand_change_incident_service_risk_v1"])
    expect(servicenow.fetch("prohibited_operations")).to include("record_write", "role_elevation")
  end
end
