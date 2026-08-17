require "yaml"

module AgenticPpm
  module Integrations
    class Policy
      CONFIG_PATH = Rails.root.join("config/agentic_ppm/integrations.yml").freeze

      def self.fetch(provider)
        providers.fetch(provider.to_s)
      end

      def self.providers
        @providers ||= YAML.safe_load_file(CONFIG_PATH, aliases: true).fetch("providers")
      end

      def self.reset!
        @providers = nil
      end
    end
  end
end
