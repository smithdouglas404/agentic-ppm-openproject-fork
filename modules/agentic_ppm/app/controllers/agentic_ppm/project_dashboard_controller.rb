module AgenticPpm
  class ProjectDashboardController < ApplicationController
    include Layout

    load_and_authorize_with_permission_in_project :view_agentic_ppm

    menu_item :agentic_ppm

    def show
      projection_records = ProjectionRecord.where(project: @project)
      project_projection = projection_records.find_by(
        entity_type: "project",
        source_type: "openproject",
        source_id: @project.id
      )
      dashboard_evidence = AgenticPpm::DashboardEvidenceService.new(
        project: @project,
        relationship_type: params[:relationship_type],
        entity_key: params[:entity_key]
      ).call

      render :show,
             locals: {
               project: @project,
               capabilities: AgenticPpm::ServiceRegistry.capability_states,
               specialist_contracts: AgenticPpm::ServiceRegistry.specialist_contracts,
               interactive_specialist_options: AgenticPpm::ServiceRegistry.interactive_specialist_options,
               projection_summary: dashboard_evidence.fetch(:projection_summary),
               relationship_types: dashboard_evidence.fetch(:relationship_types),
               selected_relationship_type: dashboard_evidence.fetch(:selected_relationship_type),
               relationship_evidence: dashboard_evidence.fetch(:relationship_evidence),
               entity_options: dashboard_evidence.fetch(:entity_options),
               selected_entity_key: dashboard_evidence.fetch(:selected_entity_key),
               inspected_entity: dashboard_evidence.fetch(:inspected_entity),
               inspection_attributes: dashboard_evidence.fetch(:inspection_attributes),
               source_review_signals: dashboard_evidence.fetch(:source_review_signals),
               delivery_method_evidence: project_projection&.payload&.fetch("delivery_method_evidence", {}) || {},
               scheduled_work_packages: dashboard_evidence.fetch(:scheduled_work_packages)
             }
    end
  end
end
