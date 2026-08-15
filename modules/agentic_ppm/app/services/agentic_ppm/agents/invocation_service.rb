module AgenticPpm
  module Agents
    class InvocationService
      INTERACTIVE_SPECIALISTS = %w[PMO VRO].freeze

      def initialize(project:, user:, specialist:, prompt:, correlation_id: SecureRandom.uuid)
        @project = project
        @user = user
        @specialist = specialist
        @prompt = prompt
        @correlation_id = correlation_id
      end

      def call
        run = AgentRun.create!(
          project:,
          user:,
          specialist: AgentRun.persisted_specialist_name(specialist),
          prompt:,
          state: initial_state,
          correlation_id:,
          evidence_references: []
        )

        Result.new(run:, available: letta_available?)
      end

      private

      Result = Data.define(:run, :available)

      attr_reader :project, :user, :specialist, :prompt, :correlation_id

      def initial_state
        letta_available? ? "requested" : "unavailable"
      end

      def letta_available?
        INTERACTIVE_SPECIALISTS.include?(specialist) && ServiceRegistry.adapter_for(:letta).capability_state == :configured
      end
    end
  end
end
