module AgenticPpm
  module ServiceAdapters
    class LangflowAdapter < BaseAdapter
      def initialize
        super(name: :langflow, enabled_environment_key: "LANGFLOW_AGENTIC_ENABLED", base_url_environment_key: "LANGFLOW_BASE_URL")
      end
    end
  end
end
