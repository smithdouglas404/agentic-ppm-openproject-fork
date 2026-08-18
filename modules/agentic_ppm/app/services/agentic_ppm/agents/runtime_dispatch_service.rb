module AgenticPpm
  module Agents
    class RuntimeDispatchService
      ROUTES = {
        "PMO" => "/api/agents/pmo/run",
        "Governance" => "/api/agents/governance/run"
      }.freeze

      def initialize(run:)
        @run = run
      end

      def call
        route = ROUTES.fetch(run.specialist) do
          raise ArgumentError, "No local runtime route is registered for #{run.specialist}"
        end

        Integrations::HttpClient.new(
          base_url: ENV.fetch("AGENTIC_PPM_AGENT_RUNTIME_BASE_URL"),
          authorization: nil
        ).post(
          route,
          payload: {
            trigger: "OpenProject AgentRun #{run.correlation_id}",
            project_id: run.project_id.to_s,
            scope: "project:#{run.project_id}"
          },
          headers: {
            "X-Agent-Key" => ENV.fetch("AGENTIC_PPM_AGENT_RUNTIME_KEY")
          }
        )
      end

      private

      attr_reader :run
    end
  end
end
