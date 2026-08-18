module AgenticPpm
  module Agents
    class InvocationService

      def initialize(project:, user:, specialist:, prompt:, correlation_id: SecureRandom.uuid)
        @project = project
        @user = user
        @specialist = specialist
        @prompt = prompt
        @correlation_id = correlation_id
      end

      def call
        existing = AgentRun.find_by(project:, correlation_id:)
        return Result.new(run: existing, available: existing.state != "unavailable") if existing

        run = AgentRun.create!(
          project:,
          user:,
          specialist: AgentRun.persisted_specialist_name(specialist),
          prompt:,
          state: initial_state,
          correlation_id:,
          evidence_references: []
        )

        available = runtime_available?
        AgenticPpm::AgentRunJob.perform_later(run.id) if available
        Result.new(run:, available:)
      end

      private

      Result = Data.define(:run, :available)

      attr_reader :project, :user, :specialist, :prompt, :correlation_id

      def initial_state
        runtime_available? ? "requested" : "unavailable"
      end

      def runtime_available?
        contract = ContractValidationService.call
        contract.valid? &&
          ServiceRegistry.adapter_for(:durable_workflow).capability_state == :configured &&
          ENV["AGENTIC_PPM_AGENT_RUNTIME_BASE_URL"].present? &&
          ENV["AGENTIC_PPM_AGENT_RUNTIME_KEY"].present? &&
          RuntimeDispatchService::ROUTES.key?(specialist)
      end
    end
  end
end
