module AgenticPpm
  module ServiceAdapters
    class BaseAdapter
      def initialize(name:, enabled_environment_key:, base_url_environment_key: nil)
        @name = name
        @enabled_environment_key = enabled_environment_key
        @base_url_environment_key = base_url_environment_key
      end

      attr_reader :name

      def capability_state
        return :disabled unless enabled?
        return :configured if base_url_environment_key.nil? || ENV[base_url_environment_key].present?

        :degraded
      end

      def enabled?
        ActiveModel::Type::Boolean.new.cast(ENV.fetch(enabled_environment_key, false))
      end

      private

      attr_reader :enabled_environment_key, :base_url_environment_key
    end
  end
end
