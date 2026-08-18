module AgenticPpm
  class GraphApiController < ApplicationController
    include AgenticPpm::ApiContract
    load_and_authorize_with_permission :view_agentic_ppm

    MAX_LIMIT = 500

    def show
      limit = [params.fetch(:limit, 100).to_i, MAX_LIMIT].min
      limit = 1 if limit < 1
      records = AgenticPpm::ProjectionRecord.where(project: @project).order(:id)
      records = records.where(entity_type: params[:entity_type]) if params[:entity_type].present?
      records = records.where(projection_state: params[:projection_state]) if params[:projection_state].present?
      records = records.limit(limit)

      render json: {
        project: { id: @project.id, identifier: @project.identifier, name: @project.name },
        nodes: records.reject { |record| record.entity_type == "relationship" }.map { |record| node_json(record) },
        edges: records.select { |record| record.entity_type == "relationship" }.map { |record| edge_json(record) },
        pagination: { limit:, returned: records.size, bounded: limit == MAX_LIMIT },
        filters: { entity_type: params[:entity_type], projection_state: params[:projection_state] }
      }
    end

    private

    def node_json(record)
      provenance_json(record).merge(
        entity_type: record.entity_type,
        entity_key: record.entity_key,
        payload: record.payload
      )
    end

    def edge_json(record)
      provenance_json(record).merge(
        entity_type: record.entity_type,
        entity_key: record.entity_key,
        payload: record.payload
      )
    end

    def provenance_json(record)
      {
        id: record.id,
        project_id: record.project_id,
        source_type: record.source_type,
        source_id: record.source_id,
        projection_state: record.projection_state,
        ontology_version: record.ontology_version,
        mapping_profile: record.mapping_profile,
        authorization_provenance: record.authorization_provenance,
        confidence: record.confidence,
        correlation_id: record.correlation_id,
        observed_at: record.observed_at&.iso8601
      }
    end
  end
end
