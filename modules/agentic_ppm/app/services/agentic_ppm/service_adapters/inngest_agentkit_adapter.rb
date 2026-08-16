module AgenticPpm
  module ServiceAdapters
    class InngestAgentkitAdapter < BaseAdapter
      def initialize
        super(
          name: :inngest_agentkit,
          enabled_environment_key: "INNGEST_AGENTIC_ENABLED",
          base_url_environment_key: "INNGEST_BASE_URL"
        )
      end
    end
  end
end
