module AgenticPpm
  module ServiceAdapters
    class MemgraphAdapter < BaseAdapter
      def initialize
        super(name: :memgraph, enabled_environment_key: "MEMGRAPH_AGENTIC_ENABLED", base_url_environment_key: "MEMGRAPH_BASE_URL")
      end
    end
  end
end
