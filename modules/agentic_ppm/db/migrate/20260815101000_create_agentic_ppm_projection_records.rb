# frozen_string_literal: true

class CreateAgenticPpmProjectionRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :agentic_ppm_projection_records do |t|
      t.references :project, null: false, foreign_key: { on_delete: :cascade }
      t.string :source_type, null: false
      t.bigint :source_id, null: false
      t.string :entity_type, null: false
      t.string :entity_key, null: false
      t.string :projection_state, null: false, default: "pending"
      t.string :idempotency_key, null: false
      t.jsonb :payload, null: false, default: {}
      t.datetime :observed_at, null: false
      t.datetime :projected_at
      t.timestamps
    end

    add_index :agentic_ppm_projection_records,
              %i[project_id source_type source_id entity_type entity_key],
              unique: true,
              name: "index_agentic_ppm_projection_entity_identity"
    add_index :agentic_ppm_projection_records,
              :idempotency_key,
              name: "index_agentic_ppm_projection_idempotency"
    add_index :agentic_ppm_projection_records,
              :projection_state,
              name: "index_agentic_ppm_projection_state"
  end
end
