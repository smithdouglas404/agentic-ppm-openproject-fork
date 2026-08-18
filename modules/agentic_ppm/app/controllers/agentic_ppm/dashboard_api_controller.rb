module AgenticPpm
  class DashboardApiController < ApplicationController
    include AgenticPpm::ApiContract
    load_and_authorize_with_permission_in_project :view_agentic_ppm

    def show
      evidence = AgenticPpm::DashboardEvidenceService.new(
        project: @project,
        relationship_type: params[:relationship_type],
        entity_key: params[:entity_key],
        alert_key: params[:alert_key]
      ).call

      render json: {
        project: {
          id: @project.id,
          identifier: @project.identifier,
          name: @project.name
        },
        capabilities: AgenticPpm::ServiceRegistry.capability_states,
        specialist_contracts: AgenticPpm::ServiceRegistry.specialist_contracts,
        projection_summary: evidence.fetch(:projection_summary),
        relationship_types: evidence.fetch(:relationship_types),
        selected_relationship_type: evidence.fetch(:selected_relationship_type),
        relationship_evidence: evidence.fetch(:relationship_evidence),
        entity_options: evidence.fetch(:entity_options),
        selected_entity_key: evidence.fetch(:selected_entity_key),
        inspected_entity: evidence.fetch(:inspected_entity),
        inspection_attributes: evidence.fetch(:inspection_attributes),
        source_review_signals: evidence.fetch(:source_review_signals),
        source_review_signal_options: evidence.fetch(:source_review_signal_options),
        selected_source_review_signal: evidence.fetch(:selected_source_review_signal),
        source_review_signal_details: evidence.fetch(:source_review_signal_details),
        scheduled_work_packages: evidence.fetch(:scheduled_work_packages),
        agent_runs: project_agent_runs
      }
    end

    private

    def project_agent_runs
      AgenticPpm::AgentRun.where(project: @project).order(created_at: :desc).limit(50).map do |run|
        {
          id: run.id,
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
    end
  end
end
