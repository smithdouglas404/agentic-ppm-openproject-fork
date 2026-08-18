module AgenticPpm
  class AgentRunsController < ApplicationController
    load_and_authorize_with_permission_in_project :run_agentic_ppm_agents

    def create
      result = AgenticPpm::Agents::InvocationService.new(
        project: @project,
        user: User.current,
        specialist: params.require(:specialist),
        prompt: params.require(:prompt)
      ).call

      respond_to do |format|
        format.html do
          flash[:notice] = result.available ? I18n.t(:agentic_ppm_agent_request_queued) : I18n.t(:agentic_ppm_agent_runtime_unavailable)
          redirect_to redirect_destination
        end
        format.json do
          render json: {
            available: result.available,
            agent_run: serialized_run(result.run)
          }, status: result.available ? :accepted : :service_unavailable
        end
      end
    end

    private

    def serialized_run(run)
      {
        id: run.id,
        project_id: run.project_id,
        specialist: run.specialist,
        state: run.state,
        correlation_id: run.correlation_id,
        prompt: run.prompt,
        response: run.response,
        evidence_references: run.evidence_references,
        created_at: run.created_at&.iso8601,
        updated_at: run.updated_at&.iso8601
      }
    end

    def redirect_destination
      return project_agentic_ppm_conversations_path(@project) if params[:return_to] == "conversations"

      project_agentic_ppm_path(@project)
    end
  end
end
