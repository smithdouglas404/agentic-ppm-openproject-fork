module AgenticPpm
  class ProjectDashboardController < ApplicationController
    include Layout

    before_action -> { load_and_authorize_with_permission_in_project :view_agentic_ppm }

    menu_item :agentic_ppm

    def show
      render :show,
             locals: {
               project: @project,
               capabilities: AgenticPpm::ServiceRegistry.capability_states,
               specialists: AgenticPpm::ServiceRegistry.specialists
             }
    end
  end
end
