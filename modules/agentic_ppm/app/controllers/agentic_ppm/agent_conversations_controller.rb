module AgenticPpm
  class AgentConversationsController < ApplicationController
    include Layout

    load_and_authorize_with_permission_in_project :run_agentic_ppm_agents

    menu_item :agentic_ppm_conversations

    def show
      workspace = AgenticPpm::Agents::ConversationWorkspaceService.new(
        project: @project,
        specialist_contracts: AgenticPpm::ServiceRegistry.specialist_contracts
      ).call

      render :show,
             locals: {
               project: @project,
               specialist_contracts: workspace.fetch(:specialist_contracts),
               agent_runs: workspace.fetch(:agent_runs),
               runtime_configured: workspace.fetch(:runtime_configured)
             }
    end
  end
end
