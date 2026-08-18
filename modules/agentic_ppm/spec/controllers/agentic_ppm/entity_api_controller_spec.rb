require "spec_helper"

RSpec.describe AgenticPpm::EntityApiController, type: :controller do
  it "uses the project permission boundary and returns source/provenance/neighbors" do
    source = File.read(Rails.root.join("modules/agentic_ppm/app/controllers/agentic_ppm/entity_api_controller.rb"))
    expect(source).to include("load_and_authorize_with_permission_in_project :view_agentic_ppm")
    expect(source).to include("ProjectionRecord.find_by!(project: @project, entity_key:)")
    expect(source).to include("authorization_provenance: record.authorization_provenance")
    expect(source).to include("neighbors:")
  end
end
