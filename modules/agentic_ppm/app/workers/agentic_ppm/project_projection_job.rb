module AgenticPpm
  class ProjectProjectionJob < ApplicationJob
    queue_as :default

    def perform(project_id, idempotency_key:)
      project = Project.find(project_id)
      return unless project.module_enabled?(:agentic_ppm)

      AgenticPpm::Ontology::ProjectProjectionService.new(project:, idempotency_key:).call
      AgenticPpm::Ontology::WorkPackageProjectionService.new(project:, idempotency_key:).call
      AgenticPpm::Ontology::WorkPackageRelationProjectionService.new(project:, idempotency_key:).call
      mark_projected!(project, idempotency_key)
    rescue StandardError => error
      record_failure!(project, idempotency_key, error) if defined?(project) && project
      raise
    end

    private

    def mark_projected!(project, idempotency_key)
      ProjectionRecord.where(project:, idempotency_key:).update_all(
        projection_state: "projected",
        updated_at: Time.current
      )
    end

    def record_failure!(project, idempotency_key, error)
      now = Time.current

      ProjectionRecord.upsert(
        {
          project_id: project.id,
          source_type: "openproject",
          source_id: project.id,
          entity_type: "project",
          entity_key: "openproject:projection_failure:#{project.id}",
          projection_state: "failed",
          idempotency_key:,
          payload: {
            phase: "project_projection_job",
            error_class: error.class.name,
            error_message: error.message.to_s.first(500)
          },
          observed_at: now,
          created_at: now,
          updated_at: now
        },
        unique_by: :index_agentic_ppm_projection_entity_identity
      )
    end
  end
end
