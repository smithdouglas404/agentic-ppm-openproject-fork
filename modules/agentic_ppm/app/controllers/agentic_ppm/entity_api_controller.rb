module AgenticPpm
  class EntityApiController < ApplicationController
    include AgenticPpm::APIContract
    load_and_authorize_with_permission_in_project :view_agentic_ppm

    def show
      entity_key = params.fetch(:entity_key)
      record = AgenticPpm::ProjectionRecord.find_by!(project: @project, entity_key:)
      neighbors = AgenticPpm::ProjectionRecord.where(project: @project, entity_type: "relationship").filter_map do |edge|
        payload = edge.payload || {}
        next unless [payload["from_key"], payload["to_key"]].include?(entity_key)

        {
          entity_key: edge.entity_key,
          relationship_type: payload["relationship_type"],
          from_key: payload["from_key"],
          to_key: payload["to_key"],
          correlation_id: edge.correlation_id,
          observed_at: edge.observed_at&.iso8601
        }
      end

      render json: {
        project: { id: @project.id, identifier: @project.identifier, name: @project.name },
        entity: {
          entity_key: record.entity_key,
          entity_type: record.entity_type,
          payload: record.payload,
          source: {
            source_type: record.source_type,
            source_id: record.source_id,
            observed_at: record.observed_at&.iso8601
          },
          provenance: {
            ontology_version: record.ontology_version,
            mapping_profile: record.mapping_profile,
            authorization_provenance: record.authorization_provenance,
            confidence: record.confidence,
            correlation_id: record.correlation_id
          }
        },
        neighbors:
      }
    rescue ActiveRecord::RecordNotFound
      render json: { error: { code: "not_found", message: "Entity is not available in this project scope" } }, status: :not_found
    end
  end
end
