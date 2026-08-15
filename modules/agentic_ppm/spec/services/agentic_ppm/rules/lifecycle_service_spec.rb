require "spec_helper"

RSpec.describe AgenticPpm::Rules::LifecycleService do
  let(:actor) { build_stubbed(:user) }

  it "requires an approved and validated visual flow before publication" do
    rule = instance_double(
      AgenticPpm::BusinessRule,
      state: "approved",
      state_approved?: true,
      visual_flow_reference: nil,
      validation_result: { "valid" => true }
    )

    expect {
      described_class.new(rule:, actor:).transition_to!("published")
    }.to raise_error(ArgumentError, "A visual flow reference is required before publication")
  end
end
