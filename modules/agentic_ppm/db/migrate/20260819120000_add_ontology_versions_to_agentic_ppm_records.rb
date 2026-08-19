# frozen_string_literal: true

class AddOntologyVersionsToAgenticPpmRecords < ActiveRecord::Migration[8.0]
  def change
    change_table :agentic_ppm_agent_runs, bulk: true do |t|
      t.string :ontology_version, null: false, default: "1"
      t.string :mapping_profile, null: false, default: "openproject-native-v1"
    end

    change_table :agentic_ppm_findings, bulk: true do |t|
      t.string :ontology_version, null: false, default: "1"
      t.string :mapping_profile, null: false, default: "openproject-native-v1"
    end

    change_table :agentic_ppm_source_records, bulk: true do |t|
      t.string :ontology_version, null: false, default: "1"
      t.string :mapping_profile, null: false, default: "openproject-native-v1"
    end

    add_index :agentic_ppm_agent_runs,
              %i[project_id ontology_version mapping_profile],
              name: "index_agentic_ppm_agent_runs_ontology_mapping"
    add_index :agentic_ppm_findings,
              %i[project_id ontology_version mapping_profile],
              name: "index_agentic_ppm_findings_ontology_mapping"
    add_index :agentic_ppm_source_records,
              %i[project_id ontology_version mapping_profile],
              name: "index_agentic_ppm_source_records_ontology_mapping"
  end
end
