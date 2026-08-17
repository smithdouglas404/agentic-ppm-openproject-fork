require "spec_helper"

RSpec.describe "Agentic PPM service adapter capability states" do
  EXTERNAL_ADAPTERS = {
    letta: [AgenticPpm::ServiceAdapters::LettaAdapter, "LETTA_AGENTIC_ENABLED", "LETTA_BASE_URL"],
    mem0: [AgenticPpm::ServiceAdapters::Mem0Adapter, "MEM0_AGENTIC_ENABLED", "MEM0_BASE_URL"],
    memgraph: [AgenticPpm::ServiceAdapters::MemgraphAdapter, "MEMGRAPH_AGENTIC_ENABLED", "MEMGRAPH_BASE_URL"],
    langflow: [AgenticPpm::ServiceAdapters::LangflowAdapter, "LANGFLOW_AGENTIC_ENABLED", "LANGFLOW_BASE_URL"],
    inngest_agentkit: [AgenticPpm::ServiceAdapters::InngestAgentkitAdapter, "INNGEST_AGENTIC_ENABLED", "INNGEST_BASE_URL"]
  }.freeze

  around do |example|
    keys = EXTERNAL_ADAPTERS.values.flat_map { |(_, enabled_key, base_url_key)| [enabled_key, base_url_key] } + ["AGENTIC_PPM_DURABLE_WORKFLOW_ENABLED"]
    original = keys.to_h { |key| [key, ENV[key]] }
    keys.each { |key| ENV.delete(key) }

    example.run
  ensure
    original.each do |key, value|
      value.nil? ? ENV.delete(key) : ENV[key] = value
    end
  end

  it "reports every external runtime as disabled unless its explicit enabled flag is set" do
    EXTERNAL_ADAPTERS.each_value do |adapter_class, _enabled_key, _base_url_key|
      expect(adapter_class.new.capability_state).to eq(:disabled)
    end

    expect(AgenticPpm::ServiceAdapters::NativeWorkflowAdapter.new.capability_state).to eq(:disabled)
  end

  it "distinguishes an explicitly enabled but incomplete external runtime as degraded" do
    EXTERNAL_ADAPTERS.each_value do |adapter_class, enabled_key, _base_url_key|
      ENV[enabled_key] = "true"

      expect(adapter_class.new.capability_state).to eq(:degraded)

      ENV.delete(enabled_key)
    end
  end

  it "reports an explicitly enabled adapter as configured only when its endpoint requirement is present" do
    EXTERNAL_ADAPTERS.each_value do |adapter_class, enabled_key, base_url_key|
      ENV[enabled_key] = "true"
      ENV[base_url_key] = "https://controlled.example"

      expect(adapter_class.new.capability_state).to eq(:configured)

      ENV.delete(enabled_key)
      ENV.delete(base_url_key)
    end

    ENV["AGENTIC_PPM_DURABLE_WORKFLOW_ENABLED"] = "true"
    expect(AgenticPpm::ServiceAdapters::NativeWorkflowAdapter.new.capability_state).to eq(:configured)
  end

  it "exposes all service states through the registry without activating a provider" do
    expect(AgenticPpm::ServiceRegistry.capability_states).to include(
      letta: :disabled,
      mem0: :disabled,
      memgraph: :disabled,
      langflow: :disabled,
      inngest_agentkit: :disabled,
      durable_workflow: :disabled
    )
  end
end
