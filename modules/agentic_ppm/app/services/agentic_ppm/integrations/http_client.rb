require "net/http"
require "json"

module AgenticPpm
  module Integrations
    class HttpClient
      def initialize(base_url:, authorization:)
        @base_url = URI(base_url)
        @authorization = authorization
        validate_base_url!
      end

      def get(path, params: {})
        uri = base_url.dup
        uri.path = [base_url.path.chomp("/"), path.sub(%r{\A/}, "")].reject(&:empty?).join("/")
        uri.query = URI.encode_www_form(params) if params.any?

        request = Net::HTTP::Get.new(uri)
        request["Accept"] = "application/json"
        request["Authorization"] = authorization if authorization.present?

        response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") { |http| http.request(request) }
        raise "External source request failed with HTTP #{response.code}" unless response.is_a?(Net::HTTPSuccess)

        JSON.parse(response.body)
      end

      private

      attr_reader :base_url, :authorization

      def validate_base_url!
        raise ArgumentError, "Integration base URL must use HTTP or HTTPS" unless base_url.is_a?(URI::HTTP)
        return if base_url.scheme == "https"
        return if ActiveModel::Type::Boolean.new.cast(ENV.fetch("AGENTIC_PPM_ALLOW_INSECURE_SERVICE_URLS", false))

        raise ArgumentError, "Integration base URL must use HTTPS unless insecure local service URLs are explicitly enabled"
      end
    end
  end
end
