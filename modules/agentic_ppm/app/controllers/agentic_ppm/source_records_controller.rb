module AgenticPpm
  class SourceRecordsController < ApplicationController
    load_and_authorize_with_permission_in_project :manage_agentic_ppm_sources

    def create
      upload = params.require(:file)
      record = AgenticPpm::SourceRecord.new(
        project: @project,
        created_by: User.current,
        source_type: params[:source_type].presence || "document",
        source_id: params[:source_id].presence || SecureRandom.uuid,
        filename: upload.respond_to?(:original_filename) ? upload.original_filename : params.require(:filename),
        content_type: upload.respond_to?(:content_type) ? upload.content_type : params.require(:content_type),
        byte_size: upload.respond_to?(:size) ? upload.size : params.require(:byte_size),
        content_sha256: params.require(:content_sha256),
        storage_key: params.require(:storage_key),
        methodology: params[:methodology],
        agent_assignment: params[:agent_assignment],
        version: next_version(params[:source_type], params[:source_id]),
        tags: Array(params[:tags]),
        column_mapping: params[:column_mapping].to_h,
        provenance: { "project_id" => @project.id, "created_by_id" => User.current.id, "observed_at" => Time.current.iso8601 },
        state: "staged"
      )

      if record.save
        render json: { source_record: serialized_record(record) }, status: :created
      else
        render json: { error: { code: "validation_error", message: record.errors.full_messages.to_sentence } }, status: :unprocessable_entity
      end
    end

    private

    def next_version(source_type, source_id)
      AgenticPpm::SourceRecord.where(project: @project, source_type: source_type, source_id: source_id).maximum(:version).to_i + 1
    end

    def serialized_record(record)
      {
        id: record.id,
        project_id: record.project_id,
        source_type: record.source_type,
        source_id: record.source_id,
        filename: record.filename,
        content_type: record.content_type,
        byte_size: record.byte_size,
        content_sha256: record.content_sha256,
        methodology: record.methodology,
        agent_assignment: record.agent_assignment,
        version: record.version,
        tags: record.tags,
        column_mapping: record.column_mapping,
        provenance: record.provenance,
        state: record.state
      }
    end
  end
end
