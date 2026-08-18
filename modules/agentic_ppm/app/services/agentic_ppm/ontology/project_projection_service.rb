module AgenticPpm
  module Ontology
    class ProjectProjectionService
      PROJECT_ENTITY_TYPE = "project"
      OPENPROJECT_SOURCE_TYPE = "openproject"

      def initialize(project:, idempotency_key:, observed_at: Time.current)
        @project = project
        @idempotency_key = idempotency_key
        @observed_at = observed_at
      end

      def call
        ProjectionRecord.upsert(
          projection_attributes,
          unique_by: :index_agentic_ppm_projection_entity_identity
        )
      end

      private

      attr_reader :project, :idempotency_key, :observed_at

      def projection_attributes
        {
          project_id: project.id,
          source_type: OPENPROJECT_SOURCE_TYPE,
          source_id: project.id,
          entity_type: PROJECT_ENTITY_TYPE,
          entity_key: "openproject:project:#{project.id}",
          projection_state: "pending",
          idempotency_key:,
          ontology_version: "1",
          mapping_profile: "openproject-native-v1",
          authorization_provenance: "openproject-project-scope",
          confidence: 1.0,
          correlation_id: idempotency_key,
          payload: {
            identifier: project.identifier,
            name: project.name,
            active: project.active?,
            delivery_method_evidence: DeliveryMethodEvidence.new(
              work_packages: project.work_packages.includes(:type)
            ).call
          },
          observed_at:,
          created_at: Time.current,
          updated_at: Time.current
        }
      end
    end
  end
end
