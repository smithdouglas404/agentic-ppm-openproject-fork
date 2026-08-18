require "spec_helper"

RSpec.describe AgenticPpm::Rules::LifecycleService do
  let(:actor) { build_stubbed(:user) }

  it "requires an approved and validated visual flow before publication" do
    rule = instance_double(
      AgenticPpm::BusinessRule,
      state: "approved",
      state_approved?: true,
      visual_flow_reference: nil,
      validation_result: { "valid" => true },
      simulation_trace: { "valid" => true }
    )

    expect {
      described_class.new(rule:, actor:).transition_to!("published")
    }.to raise_error(ArgumentError, "A visual flow reference is required before publication")
  end

  it "requires a valid simulation trace before publication" do
    rule = instance_double(
      AgenticPpm::BusinessRule,
      state: "approved",
      state_approved?: true,
      visual_flow_reference: "langflow://portfolio-risk-v2",
      validation_result: { "valid" => true },
      simulation_trace: { "valid" => false },
      approved_by: actor,
      published_at: nil
    )

    expect {
      described_class.new(rule:, actor:).transition_to!("published")
    }.to raise_error(ArgumentError, "A valid simulation trace is required before publication")
  end

  it "publishes an approved and validated visual flow with audit evidence" do
    published_at = Time.zone.parse("2026-08-16 12:00:00 UTC")
    rule = instance_double(
      AgenticPpm::BusinessRule,
      state: "approved",
      state_approved?: true,
      id: 9,
      project_id: 42,
      visual_flow_reference: "langflow://portfolio-risk-v2",
      validation_result: { "valid" => true, "flow_version" => "2" },
      validation_result_reference: "validation-1",
      simulation_trace: { "valid" => true, "trace_id" => "sim-1" },
      approved_by: actor,
      published_at: nil
    )
    allow(Time).to receive(:current).and_return(published_at)

    expect(rule).to receive(:assign_attributes).with(
      state: "published",
      approved_by: actor,
      published_at: published_at,
      last_transition_at: published_at,
      authorization_decision: {
        "project_id" => 42,
        "rule_id" => 9,
        "actor_id" => actor.id,
        "state_transition" => "approved->published",
        "flow_reference" => "langflow://portfolio-risk-v2",
        "flow_version" => "2",
        "validation_result_reference" => "validation-1",
        "authorized" => true,
        "observed_at" => published_at.iso8601
      }
    )
    expect(rule).to receive(:save!)

    described_class.new(rule:, actor:).transition_to!("published")
  end

  it "preserves publication evidence when a published rule is rolled back" do
    published_at = Time.zone.parse("2026-08-16 12:00:00 UTC")
    rule = instance_double(
      AgenticPpm::BusinessRule,
      id: 9,
      project_id: 42,
      state: "published",
      approved_by: actor,
      published_at: published_at,
      visual_flow_reference: "langflow://portfolio-risk-v2",
      validation_result: { "flow_version" => "2" },
      validation_result_reference: "validation-1",
      simulation_trace: { "valid" => true }
    )
    allow(Time).to receive(:current).and_return(published_at)

    expect(rule).to receive(:assign_attributes).with(
      state: "rolled_back",
      approved_by: actor,
      published_at: published_at,
      last_transition_at: published_at,
      authorization_decision: {
        "project_id" => 42,
        "rule_id" => 9,
        "actor_id" => actor.id,
        "state_transition" => "published->rolled_back",
        "flow_reference" => "langflow://portfolio-risk-v2",
        "flow_version" => "2",
        "validation_result_reference" => "validation-1",
        "authorized" => true,
        "observed_at" => published_at.iso8601
      }
    )
    expect(rule).to receive(:save!)

    described_class.new(rule:, actor:).transition_to!("rolled_back")
  end
end
