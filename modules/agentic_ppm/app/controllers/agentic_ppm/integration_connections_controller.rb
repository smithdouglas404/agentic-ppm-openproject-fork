module AgenticPpm
  class IntegrationConnectionsController < ApplicationController
    load_and_authorize_with_permission_in_project :manage_agentic_ppm_integrations

    def index
      connections = AgenticPpm::IntegrationConnection.where(project: @project).order(:provider, :name)
      render json: {
        project_id: @project.id,
        integrations: connections.map { |connection| serialized_connection(connection) }
      }
    end

    private

    def serialized_connection(connection)
      {
        id: connection.id,
        provider: connection.provider,
        name: connection.name,
        enabled: connection.enabled,
        capability_state: capability_state(connection),
        credential_reference: connection.credential_reference.present? ? "configured" : "missing",
        configuration: connection.configuration.to_h.except("credential", "token", "api_key", "client_secret"),
        sync_runs: connection.sync_runs.order(created_at: :desc).limit(10).map do |run|
          { id: run.id, state: run.state, mode: run.mode, created_at: run.created_at&.iso8601 }
        end
      }
    end

    def capability_state(connection)
      return "disabled" unless connection.enabled
      return "degraded" if connection.credential_reference.blank?

      "configured"
    end
  end
end
