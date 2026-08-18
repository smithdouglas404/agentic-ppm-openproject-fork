class AddLangflowEvidenceToAgenticPpmBusinessRules < ActiveRecord::Migration[8.1]
  def change
    add_column :agentic_ppm_business_rules, :simulation_trace, :jsonb, null: false, default: {}
    add_column :agentic_ppm_business_rules, :validation_result_reference, :string
    add_column :agentic_ppm_business_rules, :authorization_decision, :jsonb, null: false, default: {}
    add_column :agentic_ppm_business_rules, :last_transition_at, :datetime
  end
end
