module AgenticPpm
  module Agents
    class ConversationWorkspaceService
      INTERACTIVE_SPECIALISTS = %w[PMO VRO].freeze
      HISTORY_LIMIT = 50

      def initialize(project:, specialist_contracts:, agent_runs: nil)
        @project = project
        @specialist_contracts = specialist_contracts
        @agent_runs = agent_runs
      end

      def call
        {
          specialist_contracts: interactive_contracts,
          agent_runs: agent_runs.first(HISTORY_LIMIT),
          runtime_configured: ServiceRegistry.adapter_for(:letta).capability_state == :configured
        }
      end

      private

      attr_reader :project, :specialist_contracts

      def interactive_contracts
        specialist_contracts.select { |contract| INTERACTIVE_SPECIALISTS.include?(contract.fetch("invocation_key")) }
      end

      def agent_runs
        return @agent_runs if @agent_runs

        AgentRun.where(project: project, specialist: INTERACTIVE_SPECIALISTS)
                .includes(:user)
                .order(created_at: :desc)
                .limit(HISTORY_LIMIT)
                .to_a
      end
    end
  end
end
