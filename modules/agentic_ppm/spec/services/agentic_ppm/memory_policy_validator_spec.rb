require "spec_helper"

RSpec.describe AgenticPpm::MemoryPolicyValidator do
  it "requires the complete governed memory envelope" do
    source = File.read(Rails.root.join("modules/agentic_ppm/app/services/agentic_ppm/memory_policy_validator.rb"))
    expect(source).to include("REQUIRED_SCOPE")
    expect(source).to include("REQUIRED_CITATIONS")
    expect(source).to include("REQUIRED_TRACE")
    expect(source).to include("validate_write!")
    expect(source).to include("retention classification is required")
  end
end
