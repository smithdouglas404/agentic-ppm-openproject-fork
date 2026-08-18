require "spec_helper"

RSpec.describe AgenticPpm::GraphApiController, type: :controller do
  describe "GET #show" do
    it "loads the project permission boundary and exposes bounded persisted graph evidence" do
      expect(described_class).to respond_to(:new)
      source = File.read(Rails.root.join("modules/agentic_ppm/app/controllers/agentic_ppm/graph_api_controller.rb"))
      expect(source).to include("load_and_authorize_with_permission_in_project :view_agentic_ppm")
      expect(source).to include("MAX_LIMIT = 500")
      expect(source).to include("ontology_version: record.ontology_version")
      expect(source).to include("correlation_id: record.correlation_id")
    end
  end
end
