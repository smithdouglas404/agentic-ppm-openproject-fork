require "spec_helper"

RSpec.describe AgenticPpm::ApiContract do
  it "defines the shared native API response contract" do
    source = File.read(Rails.root.join("modules/agentic_ppm/app/controllers/concerns/agentic_ppm/api_contract.rb"))
    expect(source).to include("X-Correlation-ID")
    expect(source).to include("X-Agentic-PPM-Audit")
    expect(source).to include("correlation_id: request_correlation_id")
    expect(source).to include("def pagination_payload(page:, per_page:, total:)")
  end
end
