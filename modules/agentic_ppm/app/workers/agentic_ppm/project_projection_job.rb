module AgenticPpm
  class ProjectProjectionJob < ApplicationJob
    queue_as :default

    def perform(project_id, idempotency_key:)
      project = Project.find(project_id)
      return unless project.module_enabled?(:agentic_ppm)

      AgenticPpm::Ontology::ProjectProjectionService.new(project:, idempotency_key:).call
      AgenticPpm::Ontology::WorkPackageProjectionService.new(project:, idempotency_key:).call
      AgenticPpm::Ontology::WorkPackageRelationProjectionService.new(project:, idempotency_key:).call
    end
  end
end
