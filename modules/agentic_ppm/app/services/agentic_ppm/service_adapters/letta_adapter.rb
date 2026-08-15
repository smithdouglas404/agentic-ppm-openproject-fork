module AgenticPpm
  module ServiceAdapters
    class LettaAdapter < BaseAdapter
      def initialize
        super(name: :letta, enabled_environment_key: "LETTA_AGENTIC_ENABLED", base_url_environment_key: "LETTA_BASE_URL")
      end
    end
  end
end
