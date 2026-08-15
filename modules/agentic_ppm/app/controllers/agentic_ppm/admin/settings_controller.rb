module AgenticPpm
  module Admin
    class SettingsController < ApplicationController
      before_action :authorize_global

      def show
        render plain: I18n.t(:agentic_ppm_configuration_not_available)
      end
    end
  end
end
