module AgenticPpm
  module Admin
    class SettingsController < ApplicationController
      before_action :authorize_global

      def show
        @projects = Project.active.order(:name)
        @providers = AgenticPpm::IntegrationConnection::PROVIDERS
        @connections = AgenticPpm::IntegrationConnection.includes(:project).order(:provider, :name)
        @mapping_profiles = @providers.filter_map do |provider|
          policy = AgenticPpm::Integrations::Policy.fetch(provider)
          policy.fetch("mapping_profiles", [])
        rescue KeyError
          []
        end.flatten
      end
    end
  end
end
