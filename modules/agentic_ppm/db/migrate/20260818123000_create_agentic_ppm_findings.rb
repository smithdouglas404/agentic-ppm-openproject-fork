# frozen_string_literal: true

class CreateAgenticPpmFindings < ActiveRecord::Migration[8.0]
  def change
    create_table :agentic_ppm_findings do |t|
      t.references :project, null: false, foreign_key: { on_delete: :cascade }
      t.references :agent_run, null: false, foreign_key: { to_table: :agentic_ppm_agent_runs, on_delete: :cascade }
      t.references :created_by, null: false, foreign_key: { to_table: :users, on_delete: :restrict }
      t.string :finding_type, null: false
      t.string :severity, null: false, default: "medium"
      t.string :status, null: false, default: "proposed"
      t.text :narrative, null: false
      t.text :recommendation
      t.decimal :confidence, precision: 5, scale: 4
      t.jsonb :provenance, null: false, default: {}
      t.jsonb :evidence_references, null: false, default: []
      t.references :reviewed_by, foreign_key: { to_table: :users, on_delete: :restrict }
      t.datetime :reviewed_at
      t.text :review_note
      t.timestamps
    end

    add_index :agentic_ppm_findings, %i[project_id status created_at], name: "index_agentic_ppm_findings_project_status"
    add_index :agentic_ppm_findings, %i[agent_run_id finding_type], name: "index_agentic_ppm_findings_run_type"
  end
end
