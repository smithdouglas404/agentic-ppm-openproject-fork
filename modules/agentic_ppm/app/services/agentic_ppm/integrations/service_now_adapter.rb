module AgenticPpm
  module Integrations
    class ServiceNowAdapter < BaseAdapter
      TABLES = {
        "demand" => "demand",
        "change_request" => "change",
        "incident" => "incident",
        "cmdb_ci_service" => "service",
        "sn_risk_risk" => "risk"
      }.freeze

      def sync(mode:, correlation_id: SecureRandom.uuid)
        sync_run = request_sync(mode:, correlation_id:)
        return sync_run unless sync_run.state_requested?

        sync_run.update!(state: "running", started_at: Time.current)
        counts = configured_tables.to_h do |table_name|
          records = client.get("/api/now/table/#{table_name}", params: query_parameters)
          Array(records["result"]).each { |record| project_record(table_name, record, correlation_id:) }
          [table_name, Array(records["result"]).size]
        end
        sync_run.update!(state: "completed", finished_at: Time.current, statistics: { tables: counts })
        sync_run
      rescue StandardError => e
        sync_run&.update!(state: "failed", finished_at: Time.current, failure_message: e.message)
        raise
      end

      private

      def client
        HttpClient.new(base_url: connection.configuration.fetch("base_url"), authorization: authorization_header)
      end

      def authorization_header
        "Bearer #{ENV.fetch(connection.credential_reference)}"
      end

      def configured_tables
        Array(connection.configuration.fetch("tables", TABLES.keys)) & TABLES.keys
      end

      def query_parameters
        {
          sysparm_limit: connection.configuration.fetch("limit", 100),
          sysparm_query: connection.configuration["query"],
          sysparm_fields: "sys_id,number,short_description,state,sys_updated_on,assignment_group,assigned_to"
        }.compact
      end

      def project_record(table_name, record, correlation_id:)
        source_id = record.fetch("sys_id")
        ProjectionRecord.upsert(
          {
            project_id: connection.project_id,
            source_type: "servicenow",
            source_id: source_id,
            entity_type: TABLES.fetch(table_name),
            entity_key: "servicenow:#{table_name}:#{source_id}",
            projection_state: "pending",
            idempotency_key: correlation_id,
            payload: {
              number: record["number"],
              summary: record["short_description"],
              state: record["state"],
              updated_at: record["sys_updated_on"],
              assignment_group: record["assignment_group"],
              assigned_to: record["assigned_to"]
            },
            observed_at: Time.current,
            created_at: Time.current,
            updated_at: Time.current
          },
          unique_by: :index_agentic_ppm_projection_entity_identity
        )
      end
    end
  end
end
