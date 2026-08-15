module AgenticPpm
  module Integrations
    class JiraAdapter < BaseAdapter
      def sync(mode:, correlation_id: SecureRandom.uuid)
        sync_run = request_sync(mode:, correlation_id:)
        return sync_run unless sync_run.state_requested?

        sync_run.update!(state: "running", started_at: Time.current)
        issues = client.get("/rest/api/3/search/jql", params: { jql: connection.configuration.fetch("jql", "order by updated desc"), maxResults: 100 })
        issue_records = Array(issues["issues"])
        issue_records.each { |issue| project_issue(issue, correlation_id:) }
        sync_run.update!(state: "completed", finished_at: Time.current, statistics: { issue_count: issue_records.size })
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

      def project_issue(issue, correlation_id:)
        fields = issue.fetch("fields", {})
        key = issue.fetch("key")
        source_id = issue.fetch("id")

        ProjectionRecord.upsert(
          {
            project_id: connection.project_id,
            source_type: "jira",
            source_id: source_id.to_s,
            entity_type: "work_package",
            entity_key: "jira:issue:#{key}",
            projection_state: "pending",
            idempotency_key: correlation_id,
            payload: {
              key:,
              summary: fields["summary"],
              issue_type: fields.dig("issuetype", "name"),
              status: fields.dig("status", "name"),
              parent_key: fields.dig("parent", "key"),
              sprint: fields["sprint"],
              fix_versions: Array(fields["fixVersions"]).map { |version| version["name"] }
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
