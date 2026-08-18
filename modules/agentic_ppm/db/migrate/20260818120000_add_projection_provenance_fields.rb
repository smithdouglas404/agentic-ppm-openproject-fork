# frozen_string_literal: true

class AddProjectionProvenanceFields < ActiveRecord::Migration[8.0]
  def change
    change_table :agentic_ppm_projection_records, bulk: true do |t|
      t.string :ontology_version, null: false, default: "1"
      t.string :mapping_profile, null: false, default: "openproject-native-v1"
      t.string :authorization_provenance, null: false, default: "openproject-project-scope"
      t.decimal :confidence, precision: 5, scale: 4, null: false, default: 1.0
      t.string :correlation_id, null: false, default: "legacy-migration"
    end

    add_index :agentic_ppm_projection_records,
              %i[project_id correlation_id],
              name: "index_agentic_ppm_projection_project_correlation"
    add_index :agentic_ppm_projection_records,
              %i[ontology_version mapping_profile],
              name: "index_agentic_ppm_projection_ontology_mapping"
  end
end
