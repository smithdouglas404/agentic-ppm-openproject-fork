module AgenticPpm
  class ObservabilityApiController < ApplicationController
    include AgenticPpm::APIContract
    load_and_authorize_with_permission_in_project :view_agentic_ppm

    def show
      render json: {
        project: { id: @project.id, identifier: @project.identifier, name: @project.name },
        capabilities: AgenticPpm::ServiceRegistry.capability_states,
        projection: projection_status,
        agent_runs: agent_run_status,
        sync_runs: sync_run_status
      }
    end

    private

    def projection_status
      records = AgenticPpm::ProjectionRecord.where(project: @project)
      {
        total: records.count,
        pending: records.where(projection_state: "pending").count,
        projected: records.where(projection_state: "projected").count,
        failed: records.where(projection_state: "failed").count,
        latest_observed_at: records.maximum(:observed_at)&.iso8601,
        latest_correlation_id: records.order(observed_at: :desc).pick(:correlation_id)
      }
    end

    def agent_run_status
      runs = AgenticPpm::AgentRun.where(project: @project).order(created_at: :desc).limit(50)
      {
        total: runs.size,
        by_state: runs.group_by(&:state).transform_values(&:size),
        recent: runs.map do |run|
          {
            id: run.id,
            specialist: run.specialist,
            state: run.state,
            correlation_id: run.correlation_id,
            evidence_references: run.evidence_references,
            created_at: run.created_at&.iso8601,
            updated_at: run.updated_at&.iso8601
          }
        end
      }
    end

    def sync_run_status
      return { total: 0, by_state: {}, recent: [] } unless defined?(AgenticPpm::SyncRun)

      runs = AgenticPpm::SyncRun.where(project: @project).order(created_at: :desc).limit(50)
      {
        total: runs.size,
        by_state: runs.group_by(&:state).transform_values(&:size),
        recent: runs.map { |run| { id: run.id, state: run.state, correlation_id: run.correlation_id, statistics: run.statistics, failure_message: run.failure_message } }
      }
    end
  end
end
