module AgenticPpm
  module Integrations
    class BaseAdapter
      def initialize(connection:)
        @connection = connection
      end

      def request_sync(mode:, correlation_id: SecureRandom.uuid)
        SyncRun.create!(
          integration_connection: connection,
          project: connection.project,
          mode:,
          state: capability_state,
          correlation_id:,
          statistics: {}
        )
      end

      private

      attr_reader :connection

      def capability_state
        connection.enabled? && connection.credential_reference.present? ? "requested" : "unavailable"
      end
    end
  end
end
