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

  it "publishes an approved and validated visual flow with an audit timestamp" do
    approved_by = build_stubbed(:user)
    published_at = Time.zone.parse("2026-08-16 12:00:00 UTC")
    rule = instance_double(
      AgenticPpm::BusinessRule,
      state: "approved",
      state_approved?: true,
      visual_flow_reference: "langflow://portfolio-risk-v2",
      validation_result: { "valid" => true },
      approved_by: approved_by,
      published_at: nil
    )
    allow(Time).to receive(:current).and_return(published_at)

    expect(rule).to receive(:assign_attributes).with(
      state: "published",
      approved_by: approved_by,
      published_at: published_at
    )
    expect(rule).to receive(:save!)

    described_class.new(rule:, actor:).transition_to!("published")
  end

  it "preserves publication evidence when a published rule is rolled back" do
    approved_by = build_stubbed(:user)
    published_at = Time.zone.parse("2026-08-16 12:00:00 UTC")
    rule = instance_double(
      AgenticPpm::BusinessRule,
      state: "published",
      approved_by: approved_by,
      published_at: published_at
    )

    expect(rule).to receive(:assign_attributes).with(
      state: "rolled_back",
      approved_by: approved_by,
      published_at: published_at
    )
    expect(rule).to receive(:save!)

    described_class.new(rule:, actor:).transition_to!("rolled_back")
  end
end
