require "yaml"

module AgenticPpm
  module Ontology
    class DeliveryMethodEvidence
      def initialize(work_packages:, configuration: self.class.configuration)
        @work_packages = work_packages
        @configuration = configuration
      end

      def call
        evidence = direct_evidence
        configured_rules.each do |method, rule|
          evidence[method] = { "requires_all" => rule.fetch("requires_all") } if requirements_met?(rule, evidence)
        end

        {
          "configuration_version" => configuration.fetch("version"),
          "candidate_methods" => evidence.keys,
          "evidence" => evidence
        }
      end

      def self.configuration
        YAML.safe_load_file(Rails.root.join("config/agentic_ppm/ontology.yml"), aliases: true).fetch("delivery_method_evidence")
      end

      private

      attr_reader :work_packages, :configuration

      def configured_rules
        configuration.fetch("evidence_rules")
      end

      def direct_evidence
        configured_rules.each_with_object({}) do |(method, rule), evidence|
          next unless rule.key?("work_package_types")

          matches = work_packages.filter_map do |work_package|
            type_name = work_package.type&.name
            next unless rule.fetch("work_package_types").include?(type_name)

            { "work_package_id" => work_package.id, "type" => type_name }
          end
          evidence[method] = { "matched_work_packages" => matches } if matches.any?
        end
      end

      def requirements_met?(rule, evidence)
        rule.key?("requires_all") && rule.fetch("requires_all").all? { |method| evidence.key?(method) }
      end
    end
  end
end
