require "uri"

module AgenticPpm
  module Integrations
    class BaseAdapter
      class PolicyViolation < StandardError; end

      def initialize(connection:)
        @connection = connection
      end

      def request_sync(mode:, correlation_id: SecureRandom.uuid)
        validate_sync_request!(mode)

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

      def policy_provider
        raise NotImplementedError
      end

      def endpoint_url
        connection.configuration.fetch("endpoint_url")
      end

      def mapping_profile
        connection.configuration.fetch("mapping_profile")
      end

      def integration_policy
        Policy.fetch(policy_provider)
      end

      def validate_sync_request!(mode)
        policy = integration_policy
        raise PolicyViolation, "sync mode is not approved" unless policy.fetch("allowed_sync_modes").include?(mode.to_s)
        raise PolicyViolation, "mapping profile is not approved" unless policy.fetch("mapping_profiles").include?(mapping_profile)
        raise PolicyViolation, "endpoint URL is not approved" unless approved_endpoint_url?(endpoint_url)
      end

      def approved_endpoint_url?(value)
        uri = URI.parse(value)
        uri.is_a?(URI::HTTPS) && uri.host.present? && uri.userinfo.blank?
      rescue URI::InvalidURIError
        false
      end

      def capability_state
        connection.enabled? && connection.credential_reference.present? ? "requested" : "unavailable"
      end
    end
  end
end
