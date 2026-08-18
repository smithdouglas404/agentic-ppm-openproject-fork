module AgenticPpm
  module ServiceAdapters
    class LangflowAdapter < BaseAdapter
      DEFAULT_VALIDATE_PATH = "/api/v1/flows/validate"
      DEFAULT_SIMULATE_PATH = "/api/v1/flows/simulate"

      def initialize(http_client: nil)
        super(name: :langflow, enabled_environment_key: "LANGFLOW_AGENTIC_ENABLED", base_url_environment_key: "LANGFLOW_BASE_URL")
        @http_client = http_client
      end

      def validate_rule(rule:, actor:, project:)
        post_flow(
          path: ENV.fetch("LANGFLOW_VALIDATE_PATH", DEFAULT_VALIDATE_PATH),
          payload: rule_payload(rule: rule, actor: actor, project: project)
        )
      end

      def simulate_rule(rule:, actor:, project:, source_data:)
        post_flow(
          path: ENV.fetch("LANGFLOW_SIMULATE_PATH", DEFAULT_SIMULATE_PATH),
          payload: rule_payload(rule: rule, actor: actor, project: project).merge(
            "source_data" => source_data,
            "source_data_mode" => "authorized_sanitized_or_synthetic_only"
          )
        )
      end

      private

      attr_reader :http_client

      def post_flow(path:, payload:)
        raise "Langflow integration is unavailable" unless capability_state == :configured

        client.post(path, payload: payload, headers: { "X-OpenProject-Policy-Version" => "1" })
      end

      def client
        @http_client ||= Integrations::HttpClient.new(
          base_url: ENV.fetch("LANGFLOW_BASE_URL"),
          authorization: ENV["LANGFLOW_API_KEY"].presence && "Bearer #{ENV.fetch('LANGFLOW_API_KEY')}"
        )
      end

      def rule_payload(rule:, actor:, project:)
        {
          "project_id" => project.id,
          "rule_id" => rule.id,
          "rule_name" => rule.name,
          "category" => rule.category,
          "definition" => rule.definition,
          "visual_flow_reference" => rule.visual_flow_reference,
          "actor_id" => actor.id,
          "policy_version" => "1"
        }
      end
    end
  end
end

require_relative "../integrations/http_client"
require_relative "base_adapter"
