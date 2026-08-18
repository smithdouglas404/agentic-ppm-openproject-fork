module AgenticPpm
  module Agents
    class RuntimeDispatchService
      ROUTES = {
        "PMO" => "/api/agents/pmo/run",
        "VRO" => "/api/agents/vro/run",
        "OKR/KPI" => "/api/agents/okr-kpi/run",
        "OCM" => "/api/agents/ocm/run",
        "Governance" => "/api/agents/governance/run",
        "FinOps" => "/api/agents/finops/run",
        "TMO" => "/api/agents/tmo/run",
        "BusinessPlanning" => "/api/agents/business-planning/run"
      }.freeze

      LETTA_IDENTITIES = {
        "PMO" => "pmo-orchestrator",
        "VRO" => "vro-agent",
        "OKR/KPI" => "okr-kpi-agent",
        "OCM" => "ocm-agent",
        "Governance" => "governance-guardian",
        "FinOps" => "finops-agent",
        "TMO" => "tmo-agent",
        "BusinessPlanning" => "business-planning-agent"
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
            scope: "project:#{run.project_id}",
            agent_identity: LETTA_IDENTITIES.fetch(run.specialist),
            memory_scope: "project_user_agent"
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
