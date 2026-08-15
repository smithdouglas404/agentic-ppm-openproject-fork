# frozen_string_literal: true

class CreateAgenticPpmProjectionRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :agentic_ppm_projection_records do |t|
      t.references :project, null: false, foreign_key: { on_delete: :cascade }
      t.string :source_type, null: false
      t.string :source_id, null: false
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

    create_table :agentic_ppm_agent_runs do |t|
      t.references :project, null: false, foreign_key: { on_delete: :cascade }
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.string :specialist, null: false
      t.text :prompt, null: false
      t.text :response
      t.string :state, null: false, default: "requested"
      t.string :correlation_id, null: false
      t.jsonb :evidence_references, null: false, default: []
      t.timestamps
    end

    add_index :agentic_ppm_agent_runs,
              %i[project_id specialist created_at],
              name: "index_agentic_ppm_agent_runs_project_specialist"
    add_index :agentic_ppm_agent_runs,
              :correlation_id,
              unique: true,
              name: "index_agentic_ppm_agent_runs_correlation"

    create_table :agentic_ppm_integration_connections do |t|
      t.references :project, null: false, foreign_key: { on_delete: :cascade }
      t.string :provider, null: false
      t.string :name, null: false
      t.string :credential_reference
      t.jsonb :configuration, null: false, default: {}
      t.boolean :enabled, null: false, default: false
      t.timestamps
    end

    add_index :agentic_ppm_integration_connections,
              %i[project_id provider name],
              unique: true,
              name: "index_agentic_ppm_connection_project_provider_name"

    create_table :agentic_ppm_sync_runs do |t|
      t.references :integration_connection, null: false, foreign_key: { on_delete: :cascade }
      t.references :project, null: false, foreign_key: { on_delete: :cascade }
      t.string :mode, null: false
      t.string :state, null: false, default: "requested"
      t.string :correlation_id, null: false
      t.jsonb :statistics, null: false, default: {}
      t.text :failure_message
      t.datetime :started_at
      t.datetime :finished_at
      t.timestamps
    end

    add_index :agentic_ppm_sync_runs,
              :correlation_id,
              unique: true,
              name: "index_agentic_ppm_sync_runs_correlation"

    create_table :agentic_ppm_business_rules do |t|
      t.references :project, null: false, foreign_key: { on_delete: :cascade }
      t.references :created_by, null: false, foreign_key: { to_table: :users, on_delete: :restrict }
      t.references :approved_by, foreign_key: { to_table: :users, on_delete: :restrict }
      t.string :name, null: false
      t.string :category, null: false
      t.string :state, null: false, default: "draft"
      t.string :visual_flow_reference
      t.integer :version, null: false, default: 1
      t.jsonb :definition, null: false, default: {}
      t.jsonb :validation_result, null: false, default: {}
      t.datetime :published_at
      t.timestamps
    end

    add_index :agentic_ppm_business_rules,
              %i[project_id name version],
              unique: true,
              name: "index_agentic_ppm_rule_project_name_version"
    add_index :agentic_ppm_business_rules,
              %i[project_id state],
              name: "index_agentic_ppm_rule_project_state"
  end
end
