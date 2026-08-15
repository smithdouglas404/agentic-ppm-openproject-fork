module AgenticPpm
  module Integrations
    class Registry
      ADAPTERS = {
        "jira" => JiraAdapter,
        "servicenow" => ServiceNowAdapter
      }.freeze

      def self.adapter_for(connection)
        raise ArgumentError, "Unsupported Agentic PPM provider: #{connection.provider}" unless IntegrationConnection::PROVIDERS.include?(connection.provider)

        ADAPTERS.fetch(connection.provider, BaseAdapter).new(connection:)
      end
    end
  end
end
