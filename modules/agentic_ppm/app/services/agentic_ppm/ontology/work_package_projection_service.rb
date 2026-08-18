module AgenticPpm
  module Ontology
    class WorkPackageProjectionService
      OPENPROJECT_SOURCE_TYPE = "openproject"
      ENTITY_IDENTITY_INDEX = :index_agentic_ppm_projection_entity_identity

      def initialize(project:, idempotency_key:, observed_at: Time.current)
        @project = project
        @idempotency_key = idempotency_key
        @observed_at = observed_at
      end

      def call
        project.work_packages.includes(:type, :status, :assigned_to).find_each do |work_package|
          project_work_package(work_package)
          project_assigned_actor(work_package) if work_package.assigned_to.present?
        end
      end

      private

      attr_reader :project, :idempotency_key, :observed_at

      def project_work_package(work_package)
        ProjectionRecord.upsert(
          projection_attributes(
            source_type: OPENPROJECT_SOURCE_TYPE,
            source_id: work_package.id,
            entity_type: "work_package",
            entity_key: "openproject:work_package:#{work_package.id}",
            payload: work_package_payload(work_package)
          ),
          unique_by: ENTITY_IDENTITY_INDEX
        )

        upsert_relationship(
          source_id: work_package.id,
          entity_key: "openproject:relationship:contains:#{project.id}:#{work_package.id}",
          relationship_type: "contains",
          from_key: "openproject:project:#{project.id}",
          to_key: "openproject:work_package:#{work_package.id}"
        )

        return unless work_package.parent_id

        upsert_relationship(
          source_id: work_package.id,
          entity_key: "openproject:relationship:child_of:#{work_package.id}:#{work_package.parent_id}",
          relationship_type: "child_of",
          from_key: "openproject:work_package:#{work_package.id}",
          to_key: "openproject:work_package:#{work_package.parent_id}"
        )
      end

      def project_assigned_actor(work_package)
        actor = work_package.assigned_to

        ProjectionRecord.upsert(
          projection_attributes(
            source_type: OPENPROJECT_SOURCE_TYPE,
            source_id: actor.id,
            entity_type: "actor",
            entity_key: "openproject:actor:#{actor.id}",
            payload: { name: actor.name, type: actor.class.name }
          ),
          unique_by: ENTITY_IDENTITY_INDEX
        )

        upsert_relationship(
          source_id: work_package.id,
          entity_key: "openproject:relationship:assigned_to:#{work_package.id}:#{actor.id}",
          relationship_type: "assigned_to",
          from_key: "openproject:work_package:#{work_package.id}",
          to_key: "openproject:actor:#{actor.id}"
        )
      end

      def upsert_relationship(source_id:, entity_key:, relationship_type:, from_key:, to_key:)
        ProjectionRecord.upsert(
          projection_attributes(
            source_type: "openproject_relationship",
            source_id: source_id,
            entity_type: "relationship",
            entity_key:,
            payload: { relationship_type:, from_key:, to_key: }
          ),
          unique_by: ENTITY_IDENTITY_INDEX
        )
      end

      def projection_attributes(source_type:, source_id:, entity_type:, entity_key:, payload:)
        {
          project_id: project.id,
          source_type:,
          source_id:,
          entity_type:,
          entity_key:,
          projection_state: "pending",
          idempotency_key:,
          ontology_version: "1",
          mapping_profile: "openproject-native-v1",
          authorization_provenance: "openproject-project-scope",
          confidence: 1.0,
          correlation_id: idempotency_key,
          payload:,
          observed_at:,
          created_at: Time.current,
          updated_at: Time.current
        }
      end

      def work_package_payload(work_package)
        {
          subject: work_package.subject,
          type: { id: work_package.type_id, name: work_package.type&.name },
          status: { id: work_package.status_id, name: work_package.status&.name },
          parent_id: work_package.parent_id,
          start_date: work_package.start_date,
          due_date: work_package.due_date,
          estimated_hours: work_package.estimated_hours,
          done_ratio: work_package.done_ratio
        }
      end
    end
  end
end
