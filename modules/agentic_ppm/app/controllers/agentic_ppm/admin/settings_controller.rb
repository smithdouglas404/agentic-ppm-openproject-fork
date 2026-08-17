module AgenticPpm
  module Admin
    class SettingsController < ApplicationController
      before_action :authorize_global

      def show
        @projects = Project.active.order(:name)
        @providers = AgenticPpm::IntegrationConnection::PROVIDERS
        @connections = AgenticPpm::IntegrationConnection.includes(:project).order(:provider, :name)
      end
    end
  end
end
