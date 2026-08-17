module AgenticPpm
  module Admin
    class IntegrationConnectionsController < ApplicationController
      before_action :authorize_global

      def create
        project = Project.find(connection_params.fetch(:project_id))
        connection = AgenticPpm::IntegrationConnection.new(
          project:,
          provider: connection_params.fetch(:provider),
          name: connection_params.fetch(:name),
          credential_reference: connection_params[:credential_reference].presence,
          configuration: onboarding_metadata,
          enabled: false
        )

        if connection.save
          flash[:notice] = I18n.t(:agentic_ppm_integration_connection_saved_disabled)
        else
          flash[:error] = connection.errors.full_messages.to_sentence
        end

        redirect_to agentic_ppm_admin_settings_path
      end

      private

      def connection_params
        params.require(:integration_connection).permit(
          :project_id,
          :provider,
          :name,
          :credential_reference,
          :endpoint_url,
          :mapping_profile,
          :authentication_mode
        )
      end

      def onboarding_metadata
        connection_params.slice(:endpoint_url, :mapping_profile, :authentication_mode).to_h.compact_blank
      end
    end
  end
end
