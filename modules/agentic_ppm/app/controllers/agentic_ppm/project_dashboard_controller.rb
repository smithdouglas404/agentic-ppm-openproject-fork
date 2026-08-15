module AgenticPpm
  class ProjectDashboardController < ApplicationController
    include Layout

    load_and_authorize_with_permission_in_project :view_agentic_ppm

    menu_item :agentic_ppm

    def show
      projection_records = ProjectionRecord.where(project: @project)

      render :show,
             locals: {
               project: @project,
               capabilities: AgenticPpm::ServiceRegistry.capability_states,
               specialists: AgenticPpm::ServiceRegistry.specialists,
               projection_summary: projection_records.group(:entity_type).count,
               relationship_evidence: projection_records.where(entity_type: "relationship").order(updated_at: :desc).limit(12)
             }
    end
  end
end
