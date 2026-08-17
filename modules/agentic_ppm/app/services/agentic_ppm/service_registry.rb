require "yaml"

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

    class << self
      def capability_states
        ADAPTERS.transform_values do |adapter_class|
          adapter_class.new.capability_state
        end
      end

      def specialists
        specialist_contracts.map { |contract| contract.fetch("name") }
      end

      def specialist_contracts
        YAML.safe_load_file(Rails.root.join("config/agentic_ppm/agents.yml"), aliases: true).fetch("agents")
      end

      def interactive_specialist_options
        specialist_contracts.filter_map do |contract|
          [contract.fetch("name"), contract.fetch("invocation_key")] if contract.fetch("interactive")
        end
      end

      def adapter_for(service)
        ADAPTERS.fetch(service).new
      end
    end
  end
end
