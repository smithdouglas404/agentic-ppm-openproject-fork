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

      def get(path, params: {}, headers: {})
        uri = request_uri(path)
        uri.query = URI.encode_www_form(params) if params.any?

        request = Net::HTTP::Get.new(uri)
        request["Accept"] = "application/json"
        request["Authorization"] = authorization if authorization.present?
        headers.each { |name, value| request[name] = value }

        response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") { |http| http.request(request) }
        raise "External source request failed with HTTP #{response.code}: #{response.body.to_s.first(500)}" unless response.is_a?(Net::HTTPSuccess)

        JSON.parse(response.body)
      end

      def post(path, payload:, headers: {})
        uri = request_uri(path)

        request = Net::HTTP::Post.new(uri)
        request["Accept"] = "application/json"
        request["Content-Type"] = "application/json"
        request["Authorization"] = authorization if authorization.present?
        headers.each { |name, value| request[name] = value }
        request.body = JSON.generate(payload)

        response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") { |http| http.request(request) }
        raise "External source request failed with HTTP #{response.code}: #{response.body.to_s.first(500)}" unless response.is_a?(Net::HTTPSuccess)

        JSON.parse(response.body)
      end

      private

      attr_reader :base_url, :authorization

      def request_uri(path)
        path_string = path.to_s
        if path_string.match?(%r{\Ahttps?://}i)
          raise ArgumentError, "Integration request path must be relative"
        end

        relative_path = path_string.sub(%r{\A/+}, "")
        base_path = base_url.path.to_s.sub(%r{\A/+}, "").chomp("/")
        joined_path = [base_path, relative_path].reject(&:empty?).join("/")
        uri = base_url.dup
        uri.path = joined_path.empty? ? "/" : "/#{joined_path}"
        uri
      end

      def validate_base_url!
        raise ArgumentError, "Integration base URL must use HTTP or HTTPS" unless base_url.is_a?(URI::HTTP)
        return if base_url.scheme == "https"
        return if ActiveModel::Type::Boolean.new.cast(ENV.fetch("AGENTIC_PPM_ALLOW_INSECURE_SERVICE_URLS", false))

        raise ArgumentError, "Integration base URL must use HTTPS unless insecure local service URLs are explicitly enabled"
      end
    end
  end
end
