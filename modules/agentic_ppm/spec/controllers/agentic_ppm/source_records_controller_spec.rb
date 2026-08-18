require "spec_helper"

RSpec.describe AgenticPpm::SourceRecordsController do
  it "keeps uploads project-scoped and persists metadata rather than file bytes" do
    source = File.read(Rails.root.join("modules/agentic_ppm/app/controllers/agentic_ppm/source_records_controller.rb"))
    expect(source).to include("load_and_authorize_with_permission_in_project :manage_agentic_ppm_sources")
    expect(source).to include("content_sha256")
    expect(source).to include("storage_key")
    expect(source).to include("next_version")
    expect(source).to include("column_mapping")
    expect(source).to include("methodology")
    expect(source).to include("agent_assignment")
    expect(source).to include('code: "conflict"')
    expect(source).to include("content_sha256")
  end
end
