require "uri"

module AgenticPpm
  class IntegrationConnection < ApplicationRecord
    PROVIDERS = %w[openproject jira servicenow dynatrace finops].freeze
    GOVERNED_POLICY_PROVIDERS = %w[jira servicenow].freeze

    self.table_name = "agentic_ppm_integration_connections"

    belongs_to :project
    has_many :sync_runs, class_name: "AgenticPpm::SyncRun", dependent: :destroy

    validates :provider, inclusion: { in: PROVIDERS }
    validates :name, presence: true
    validates :credential_reference, exclusion: { in: [nil, ""] }, if: :enabled?
    validate :governed_configuration_matches_policy, if: :governed_policy_provider?

    private

    def governed_policy_provider?
      GOVERNED_POLICY_PROVIDERS.include?(provider)
    end

    def governed_configuration_matches_policy
      policy = AgenticPpm::Integrations::Policy.fetch(provider)
      metadata = configuration.to_h
      endpoint_url = metadata["endpoint_url"]

      validate_endpoint_url(endpoint_url)
      validate_mapping_profile(metadata["mapping_profile"], policy)
      validate_authentication_mode(metadata["authentication_mode"], policy)
      validate_policy_metadata(metadata, policy)
    end

    def validate_endpoint_url(endpoint_url)
      uri = URI.parse(endpoint_url.to_s)
      return if uri.is_a?(URI::HTTPS) && uri.host.present? && uri.userinfo.blank?

      errors.add(:configuration, "requires an HTTPS endpoint URL without embedded credentials")
    rescue URI::InvalidURIError
      errors.add(:configuration, "requires a valid HTTPS endpoint URL")
    end

    def validate_mapping_profile(mapping_profile, policy)
      return if policy.fetch("mapping_profiles").include?(mapping_profile)

      errors.add(:configuration, "uses an unapproved mapping profile")
    end

    def validate_authentication_mode(authentication_mode, policy)
      return if policy.dig("authorization", "allowed_modes").include?(authentication_mode)

      errors.add(:configuration, "uses an unapproved authentication mode")
    end

    def validate_policy_metadata(metadata, policy)
      errors.add(:configuration, "does not match the current policy version") unless metadata["policy_version"] == policy.fetch("policy_version")
      errors.add(:configuration, "must remain disabled pending verification") unless metadata["activation"] == "disabled_by_default"
      errors.add(:configuration, "must remain read-only") unless metadata["allowed_sync_modes"] == policy.fetch("allowed_sync_modes")
      errors.add(:configuration, "must retain required provenance fields") unless metadata["required_provenance"] == policy.fetch("required_provenance")
    end
  end
end
