# frozen_string_literal: true

class CreateAgenticPpmSourceRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :agentic_ppm_source_records do |t|
      t.references :project, null: false, foreign_key: { on_delete: :cascade }
      t.references :created_by, null: false, foreign_key: { to_table: :users, on_delete: :restrict }
      t.string :source_type, null: false
      t.string :source_id, null: false
      t.string :filename, null: false
      t.string :content_type, null: false
      t.bigint :byte_size, null: false
      t.string :content_sha256, null: false
      t.string :storage_key, null: false
      t.string :methodology
      t.string :agent_assignment
      t.integer :version, null: false, default: 1
      t.jsonb :tags, null: false, default: []
      t.jsonb :column_mapping, null: false, default: {}
      t.jsonb :provenance, null: false, default: {}
      t.string :state, null: false, default: "staged"
      t.timestamps
    end

    add_index :agentic_ppm_source_records,
              %i[project_id source_type source_id version],
              unique: true,
              name: "index_agentic_ppm_source_records_identity"
    add_index :agentic_ppm_source_records,
              %i[project_id content_sha256],
              name: "index_agentic_ppm_source_records_project_hash"
  end
end
