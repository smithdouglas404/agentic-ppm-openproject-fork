module AgenticPpm
  module ServiceAdapters
    class Mem0Adapter < BaseAdapter
      def initialize
        super(name: :mem0, enabled_environment_key: "MEM0_AGENTIC_ENABLED", base_url_environment_key: "MEM0_BASE_URL")
      end
    end
  end
end
