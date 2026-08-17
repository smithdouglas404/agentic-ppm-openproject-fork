module AgenticPpm
  class RulesController < ApplicationController
    include Layout

    load_and_authorize_with_permission_in_project :manage_agentic_ppm_rules

    before_action :find_rule, only: %i[update transition]

    def index
      @rules = @project.business_rules.order(updated_at: :desc)
      @new_rule = @project.business_rules.build(state: "draft")
    end

    def create
      @new_rule = @project.business_rules.build(rule_attributes.merge(created_by: User.current, state: "draft", definition: native_definition))

      if @new_rule.save
        flash[:notice] = I18n.t(:agentic_ppm_rule_created)
        redirect_to project_agentic_ppm_rules_path(@project)
      else
        @rules = @project.business_rules.order(updated_at: :desc)
        render :index, status: :unprocessable_entity
      end
    end

    def update
      if @rule.update(rule_attributes)
        flash[:notice] = I18n.t(:agentic_ppm_rule_updated)
      else
        flash[:error] = @rule.errors.full_messages.to_sentence
      end

      redirect_to agentic_ppm_rules_path(@project)
    end

    def transition
      Rules::LifecycleService.new(rule: @rule, actor: User.current).transition_to!(params.require(:target_state))
      flash[:notice] = I18n.t(:agentic_ppm_rule_transitioned, state: @rule.state.humanize)
    rescue ArgumentError => error
      flash[:error] = error.message
    ensure
      redirect_to agentic_ppm_rules_path(@project)
    end

    private

    def find_rule
      @rule = @project.business_rules.find(params[:id])
    end

    def rule_attributes
      params.require(:business_rule).permit(:name, :category, :visual_flow_reference)
    end

    def native_definition
      {
        managed_by: "openproject_agentic_ppm",
        visual_flow_status: "unvalidated_external_runtime"
      }
    end
  end
end
