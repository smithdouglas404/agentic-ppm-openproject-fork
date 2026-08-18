module AgenticPpm
  class AgentRunsController < ApplicationController
    load_and_authorize_with_permission_in_project :run_agentic_ppm_agents

    def index
      runs = AgenticPpm::AgentRun.where(project: @project).order(created_at: :desc)
      runs = runs.where(specialist: params[:specialist]) if params[:specialist].present?
      runs = runs.where(state: params[:state]) if params[:state].present?
      runs = runs.where("created_at >= ?", Time.iso8601(params[:from])) if params[:from].present?
      runs = runs.where("created_at <= ?", Time.iso8601(params[:to])) if params[:to].present?

      render json: {
        project_id: @project.id,
        agent_runs: runs.limit(100).map { |run| serialized_run(run) },
        filters: params.slice(:specialist, :state, :from, :to)
      }
    rescue ArgumentError
      render json: { error: { code: "validation_error", message: "Invalid date filter" } }, status: :unprocessable_entity
    end

    def show
      run = AgenticPpm::AgentRun.find_by!(project: @project, id: params[:id])
      render json: { agent_run: serialized_run(run).merge(audit: audit_context(run)) }
    rescue ActiveRecord::RecordNotFound
      render json: { error: { code: "not_found", message: "Agent run is not available in this project scope" } }, status: :not_found
    end

    def create
      result = AgenticPpm::Agents::InvocationService.new(
        project: @project,
        user: User.current,
        specialist: params.require(:specialist),
        prompt: params.require(:prompt),
        correlation_id: params[:idempotency_key].presence || params[:correlation_id].presence || SecureRandom.uuid
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
        trace_references: run.respond_to?(:trace_references) ? run.trace_references : [],
        memory_trace: run.respond_to?(:memory_trace) ? run.memory_trace : {},
        graph_evidence: run.respond_to?(:graph_evidence) ? run.graph_evidence : {},
        created_at: run.created_at&.iso8601,
        updated_at: run.updated_at&.iso8601
      }
    end

    def audit_context(run)
      {
        project_id: run.project_id,
        correlation_id: run.correlation_id,
        evidence_references: run.evidence_references,
        authorization: "project-scoped"
      }
    end

    def redirect_destination
      return project_agentic_ppm_conversations_path(@project) if params[:return_to] == "conversations"

      project_agentic_ppm_path(@project)
    end
  end
end
