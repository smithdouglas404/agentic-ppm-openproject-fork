module AgenticPpm
  module Agents
    class ContractValidationService
      REQUIRED_SPECIALISTS = %w[
        PMO
        VRO
        OKR/KPI
        OCM
        Governance
        FinOps
        TMO
        BusinessPlanning
      ].freeze

      Result = Data.define(:valid?, :errors)

      def self.call
        new.call
      end

      def call
        errors = []
        missing_routes = REQUIRED_SPECIALISTS.reject { |specialist| RuntimeDispatchService::ROUTES.key?(specialist) }
        missing_identities = REQUIRED_SPECIALISTS.reject { |specialist| RuntimeDispatchService::LETTA_IDENTITIES.key?(specialist) }
        errors << "missing runtime routes: #{missing_routes.join(', ')}" if missing_routes.any?
        errors << "missing Letta identities: #{missing_identities.join(', ')}" if missing_identities.any?
        errors << "specialist route and identity counts differ" unless RuntimeDispatchService::ROUTES.size == RuntimeDispatchService::LETTA_IDENTITIES.size
        Result.new(valid?: errors.empty?, errors: errors.freeze)
      end
    end
  end
end
