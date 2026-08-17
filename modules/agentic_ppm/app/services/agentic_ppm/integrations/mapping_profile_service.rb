module AgenticPpm
  module Integrations
    class MappingProfileService
      class InvalidMappingProfile < StandardError; end
      class UnsupportedSourceEntity < StandardError; end

      def initialize(provider:, mapping_profile:)
        @provider = provider.to_s
        @mapping_profile = mapping_profile
        @policy = Policy.fetch(@provider)
      end

      def map(source_entity:, metadata:)
        source_entity = source_entity.to_s

        raise InvalidMappingProfile unless policy.fetch("mapping_profiles").include?(mapping_profile)
        raise UnsupportedSourceEntity unless policy.fetch("mapping").key?(source_entity)

        {
          "provider" => provider,
          "source_entity" => source_entity,
          "ontology_target" => policy.fetch("mapping").fetch(source_entity),
          "mapping_profile" => mapping_profile,
          "attributes" => metadata.stringify_keys.slice(*allowed_fields_for(source_entity))
        }
      end

      private

      attr_reader :provider, :mapping_profile, :policy

      def allowed_fields_for(source_entity)
        fields = policy.fetch("field_allow_lists")

        return fields.fetch(source_entity, fields.fetch("common", [])) if provider == "servicenow"

        fields.fetch(jira_field_family(source_entity), [])
      end

      def jira_field_family(source_entity)
        return "sprint" if source_entity == "sprint"
        return "board" if source_entity == "board"

        "issue"
      end
    end
  end
end
