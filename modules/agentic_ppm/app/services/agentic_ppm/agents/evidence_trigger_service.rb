module AgenticPpm
  module Agents
    class EvidenceTriggerService
      def initialize(project:, idempotency_key:)
        @project = project
        @idempotency_key = idempotency_key
      end

      def call
        return unavailable unless runtime_configured?
        return existing_run if existing_run

        InvocationService.new(
          project:,
          user: User.system,
          specialist: "PMO",
          prompt: "Assess the newly projected OpenProject evidence for delivery completeness, dependencies, and escalation-ready risks.",
          correlation_id: correlation_id
        ).call
      end

      private

      attr_reader :project, :idempotency_key

      def correlation_id
        "pmo-evidence:#{project.id}:#{idempotency_key}"
      end

      def existing_run
        AgentRun.find_by(correlation_id:)
      end

      def runtime_configured?
        ServiceRegistry.adapter_for(:durable_workflow).capability_state == :configured &&
          ENV["AGENTIC_PPM_AGENT_RUNTIME_BASE_URL"].present? &&
          ENV["AGENTIC_PPM_AGENT_RUNTIME_KEY"].present?
      end

      def unavailable
        { available: false, reason: "agent_runtime_not_configured" }
      end
    end
  end
end
