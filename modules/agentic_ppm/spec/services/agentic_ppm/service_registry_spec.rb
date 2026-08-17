require "spec_helper"

RSpec.describe AgenticPpm::ServiceRegistry do
  describe ".capability_states" do
    it "reports disabled capability states unless a service is explicitly enabled" do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("LETTA_AGENTIC_ENABLED", false).and_return("true")

      expect(described_class.capability_states).to include(
        letta: :degraded,
        memgraph: :disabled,
        inngest_agentkit: :disabled
      )
    end
  end

  describe ".adapter_for" do
    it "resolves a native adapter for each service without making an external call" do
      expect(described_class.adapter_for(:memgraph)).to be_a(AgenticPpm::ServiceAdapters::MemgraphAdapter)
      expect(described_class.adapter_for(:inngest_agentkit)).to be_a(AgenticPpm::ServiceAdapters::InngestAgentkitAdapter)
    end
  end

  describe ".specialists" do
    it "provides the required specialist names" do
      expect(described_class.specialists).to contain_exactly(
        "PMO Agent", "VRO Agent", "OKR/KPI Agent", "OCM Agent", "Governance Agent", "FinOps Agent", "TMO Agent", "Business Planning Agent"
      )
    end
  end

  describe ".interactive_specialist_options" do
    it "keeps exact display names separate from supported inactive-runtime invocation keys" do
      expect(described_class.interactive_specialist_options).to contain_exactly(
        ["PMO Agent", "PMO"],
        ["VRO Agent", "VRO"]
      )
    end
  end
end
