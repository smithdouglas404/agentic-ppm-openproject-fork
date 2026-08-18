module AgenticPpm
  module APIContract
    extend ActiveSupport::Concern

    included do
      after_action :set_agentic_ppm_headers
    end

    private

    def render_api_error(code:, message:, status:, details: {})
      render json: {
        error: {
          code: code,
          message: message,
          details: details,
          correlation_id: request_correlation_id
        }
      }, status:
    end

    def request_correlation_id
      request.headers["X-Correlation-ID"].presence || response.headers["X-Correlation-ID"].presence || SecureRandom.uuid
    end

    def pagination_payload(page:, per_page:, total:)
      {
        page: page,
        per_page: per_page,
        total: total,
        pages: (total.to_f / per_page).ceil
      }
    end

    def set_agentic_ppm_headers
      response.headers["X-Correlation-ID"] = request_correlation_id
      response.headers["X-Agentic-PPM-Audit"] = "project-scoped"
    end
  end
end
