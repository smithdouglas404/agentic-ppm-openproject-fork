module AgenticPpm
  class AgentRunsController < ApplicationController
    before_action -> { load_and_authorize_with_permission_in_project :run_agentic_ppm_agents }

    def create
      result = AgenticPpm::Agents::InvocationService.new(
        project: @project,
        user: User.current,
        specialist: params.require(:specialist),
        prompt: params.require(:prompt)
      ).call

      flash[:notice] = result.available ? I18n.t(:agentic_ppm_agent_request_queued) : I18n.t(:agentic_ppm_agent_runtime_unavailable)
      redirect_to redirect_destination
    end

    private

    def redirect_destination
      return project_agentic_ppm_conversations_path(@project) if params[:return_to] == "conversations"

      project_agentic_ppm_path(@project)
    end
  end
end
