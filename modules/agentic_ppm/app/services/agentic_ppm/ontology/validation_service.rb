module AgenticPpm
  module Ontology
    class ValidationService
      DEFAULT_MAPPING_PROFILE = "openproject-native-v1"
      DEFAULT_ONTOLOGY_VERSION = "1"

      ENTITY_FIELDS = {
        "project" => %w[identifier name active delivery_method_evidence],
        "work_package" => %w[id subject status type start_date due_date estimated_hours derived_relations],
        "source_record" => %w[source_type source_id filename methodology column_mapping provenance]
      }.freeze

      def initialize(entity_type:, payload:, ontology_version: DEFAULT_ONTOLOGY_VERSION,
                     mapping_profile: DEFAULT_MAPPING_PROFILE, required_fields: [])
        @entity_type = entity_type.to_s
        @payload = payload.to_h.stringify_keys
        @ontology_version = ontology_version.to_s
        @mapping_profile = mapping_profile.to_s
        @required_fields = Array(required_fields).map(&:to_s)
      end

      def call
        unmapped_fields = payload.keys - allowed_fields
        missing_required = required_fields.reject { |field| payload.key?(field) && !blank?(payload[field]) }

        {
          valid: unmapped_fields.empty? && missing_required.empty?,
          ontology_version: ontology_version,
          mapping_profile: mapping_profile,
          entity_type: entity_type,
          unmapped_fields: unmapped_fields.sort,
          missing_required_fields: missing_required.sort,
          errors: validation_errors(unmapped_fields, missing_required)
        }
      end

      private

      attr_reader :entity_type, :payload, :ontology_version, :mapping_profile, :required_fields

      def allowed_fields
        ENTITY_FIELDS.fetch(entity_type, payload.keys)
      end

      def validation_errors(unmapped_fields, missing_required)
        [].tap do |errors|
          errors << "unmapped_fields:#{unmapped_fields.sort.join(',')}" if unmapped_fields.any?
          errors << "missing_required_fields:#{missing_required.sort.join(',')}" if missing_required.any?
        end
      end

      def blank?(value)
        value.respond_to?(:blank?) ? value.blank? : value.nil? || value == ""
      end
    end
  end
end
