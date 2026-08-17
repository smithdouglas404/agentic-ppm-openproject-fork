require "spec_helper"

RSpec.describe Project do
  it "exposes the native Agentic PPM business-rules association through the engine patch" do
    reflection = described_class.reflect_on_association(:business_rules)

    expect(reflection).to be_present
    expect(reflection.class_name).to eq("AgenticPpm::BusinessRule")
    expect(reflection.options.fetch(:dependent)).to eq(:destroy)
  end
end
