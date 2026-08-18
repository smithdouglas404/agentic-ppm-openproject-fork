module AgenticPpm
  module Agents
    class OpenprojectEvidenceHandoffService
      MAX_RECORDS = 500

      def initialize(project:, idempotency_key:)
        @project = project
        @idempotency_key = idempotency_key
      end

      def call
        return record_unavailable! unless configured?

        response = Integrations::HttpClient.new(
          base_url: ENV.fetch("AGENTIC_PPM_AGENT_RUNTIME_BASE_URL"),
          authorization: nil
        ).post(
          "/api/openproject/evidence",
          payload: payload,
          headers: { "X-Agent-Key" => ENV.fetch("AGENTIC_PPM_AGENT_RUNTIME_KEY") }
        )

        record_result!("projected", response)
        response
      rescue StandardError => error
        record_result!("failed", error_class: error.class.name, error_message: error.message.to_s.first(500))
        { "accepted" => false, "error" => "handoff_failed" }
      end

      private

      attr_reader :project, :idempotency_key

      def configured?
        ENV["AGENTIC_PPM_AGENT_RUNTIME_BASE_URL"].present? && ENV["AGENTIC_PPM_AGENT_RUNTIME_KEY"].present?
      end

      def payload
        {
          project_id: project.id.to_s,
          idempotency_key: idempotency_key,
          generated_at: Time.current.iso8601,
          records: records.map do |record|
            {
              source_type: record.source_type,
              source_id: record.source_id,
              entity_type: record.entity_type,
              entity_key: record.entity_key,
              projection_state: record.projection_state,
              observed_at: record.observed_at.iso8601,
              payload: record.payload
            }
          end
        }
      end

      def records
        ProjectionRecord.where(project:, idempotency_key:, projection_state: "projected")
                        .order(:entity_key)
                        .limit(MAX_RECORDS)
      end

      def record_unavailable!
        record_result!("projected", accepted: false, reason: "agent_runtime_not_configured")
        { "accepted" => false, "reason" => "agent_runtime_not_configured" }
      end

      def record_result!(state, result)
        now = Time.current
        ProjectionRecord.upsert(
          {
            project_id: project.id,
            source_type: "openproject",
            source_id: project.id,
            entity_type: "project",
            entity_key: "openproject:agent_handoff:#{project.id}",
            projection_state: state,
            idempotency_key: idempotency_key,
            payload: { phase: "openproject_evidence_handoff", result: result },
            observed_at: now,
            created_at: now,
            updated_at: now
          },
          unique_by: :index_agentic_ppm_projection_entity_identity
        )
      end
    end
  end
end
