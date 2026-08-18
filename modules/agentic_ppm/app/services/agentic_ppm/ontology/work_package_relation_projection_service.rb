module AgenticPpm
  module Ontology
    class WorkPackageRelationProjectionService
      ENTITY_IDENTITY_INDEX = :index_agentic_ppm_projection_entity_identity

      def initialize(project:, idempotency_key:, observed_at: Time.current)
        @project = project
        @idempotency_key = idempotency_key
        @observed_at = observed_at
      end

      def call
        work_package_ids = project.work_packages.pluck(:id)
        return if work_package_ids.empty?

        Relation.where(from_id: work_package_ids, to_id: work_package_ids).find_each do |relation|
          project_relation(relation)
        end
      end

      private

      attr_reader :project, :idempotency_key, :observed_at

      def project_relation(relation)
        ProjectionRecord.upsert(
          {
            project_id: project.id,
            source_type: "openproject_relation",
            source_id: relation.id,
            entity_type: "relationship",
            entity_key: "openproject:relationship:#{relation.relation_type}:#{relation.from_id}:#{relation.to_id}",
            projection_state: "pending",
            idempotency_key:,
            ontology_version: "1",
            mapping_profile: "openproject-native-v1",
            authorization_provenance: "openproject-project-scope",
            confidence: 1.0,
            correlation_id: idempotency_key,
            payload: {
              relationship_type: relation.relation_type,
              from_key: "openproject:work_package:#{relation.from_id}",
              to_key: "openproject:work_package:#{relation.to_id}"
            },
            observed_at:,
            created_at: Time.current,
            updated_at: Time.current
          },
          unique_by: ENTITY_IDENTITY_INDEX
        )
      end
    end
  end
end
