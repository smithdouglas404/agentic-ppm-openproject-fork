module AgenticPpm
  module Admin
    class IntegrationConnectionsController < ApplicationController
      before_action :authorize_global

      def create
        project = Project.find(connection_params.fetch(:project_id))
        policy = Integrations::Policy.fetch(connection_params.fetch(:provider))
        authentication_mode = connection_params[:authentication_mode].presence || policy.dig("authorization", "preferred_mode")

        unless policy.dig("authorization", "allowed_modes").include?(authentication_mode)
          flash[:error] = I18n.t(:agentic_ppm_integration_unsupported_authentication_mode)
          redirect_to agentic_ppm_admin_settings_path
          return
        end

        connection = AgenticPpm::IntegrationConnection.new(
          project:,
          provider: connection_params.fetch(:provider),
          name: connection_params.fetch(:name),
          credential_reference: connection_params[:credential_reference].presence,
          configuration: onboarding_metadata(policy:, authentication_mode:),
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

      def onboarding_metadata(policy:, authentication_mode:)
        connection_params.slice(:endpoint_url, :mapping_profile).to_h.compact_blank.merge(
          "authentication_mode" => authentication_mode,
          "policy_version" => policy.fetch("policy_version"),
          "allowed_sync_modes" => policy.fetch("allowed_sync_modes"),
          "activation" => policy.fetch("activation"),
          "required_provenance" => policy.fetch("required_provenance")
        )
      end
    end
  end
end
