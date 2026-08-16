module AgenticPpm
  class ServiceRegistry
    ADAPTERS = {
      letta: ServiceAdapters::LettaAdapter,
      mem0: ServiceAdapters::Mem0Adapter,
      memgraph: ServiceAdapters::MemgraphAdapter,
      langflow: ServiceAdapters::LangflowAdapter,
      inngest_agentkit: ServiceAdapters::InngestAgentkitAdapter,
      durable_workflow: ServiceAdapters::NativeWorkflowAdapter
    }.freeze

    SPECIALISTS = ["PMO", "VRO", "OKR/KPI", "OCM", "Governance", "FinOps", "TMO", "Business Planning"].freeze

    class << self
      def capability_states
        ADAPTERS.transform_values do |adapter_class|
          adapter_class.new.capability_state
        end
      end

      def specialists
        SPECIALISTS
      end

      def adapter_for(service)
        ADAPTERS.fetch(service).new
      end
    end
  end
end
