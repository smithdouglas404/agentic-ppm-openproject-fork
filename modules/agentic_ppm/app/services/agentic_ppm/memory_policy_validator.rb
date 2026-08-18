require "yaml"

module AgenticPpm
  class MemoryPolicyValidator
    REQUIRED_SCOPE = %w[workspace_id project_id openproject_user_id agent_invocation_key authorization_policy].freeze
    REQUIRED_CITATIONS = %w[source_system source_record_identity observed_at authorization_provenance memory_policy_version].freeze
    REQUIRED_TRACE = %w[memory_operation workspace_id project_id openproject_user_id agent_invocation_key authorization_decision source_citation_references retention_classification].freeze

    def self.validate_write!(envelope)
      validate_scope!(envelope)
      validate_required!(envelope.fetch(:source_citations), REQUIRED_CITATIONS, "source_citations")
      validate_required!(envelope.fetch(:trace), REQUIRED_TRACE, "trace")
      raise ArgumentError, "content classification is required" if envelope[:content_classification].blank?
      raise ArgumentError, "retention classification is required" if envelope[:retention_classification].blank?
      true
    end

    def self.validate_scope!(envelope)
      validate_required!(envelope, REQUIRED_SCOPE, "scope")
    end

    def self.validate_required!(value, keys, label)
      keys.each do |key|
        symbol = key.to_sym
        string = key.to_s
        present = value.respond_to?(:key?) && (value.key?(symbol) || value.key?(string))
        raise ArgumentError, "#{label} is missing #{key}" unless present && value[symbol].presence || value[string].presence
      end
    end

    private_class_method :validate_required!
  end
end
