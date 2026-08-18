module AgenticPpm
  class AgentRunPollJob < ApplicationJob
    queue_as :default
    MAX_ATTEMPTS = 30

    def perform(agent_run_id, external_job_id, attempts: 0)
      run = AgentRun.find(agent_run_id)
      return if run.state.in?(%w[completed failed unavailable])

      result = Integrations::HttpClient.new(
        base_url: ENV.fetch("AGENTIC_PPM_AGENT_RUNTIME_BASE_URL"),
        authorization: nil
      ).get(
        "/api/agents/job/#{external_job_id}",
        headers: { "X-Agent-Key" => ENV.fetch("AGENTIC_PPM_AGENT_RUNTIME_KEY") }
      )

      case result.fetch("status")
      when "complete"
        persist!(run, "completed", result)
      when "error"
        persist!(run, "failed", result)
      else
        if attempts < MAX_ATTEMPTS
          self.class.set(wait: 2.seconds).perform_later(run.id, external_job_id, attempts: attempts + 1)
        else
          persist!(run, "failed", "error" => "agent_runtime_timeout", "external_job_id" => external_job_id)
        end
      end
    rescue StandardError => error
      run.update_columns(
        state: "failed",
        response: JSON.generate(
          "error" => "agent_runtime_poll_failed",
          "error_class" => error.class.name,
          "message" => error.message.to_s.first(500)
        ),
        updated_at: Time.current
      ) if defined?(run) && run
      raise
    end

    private

    def persist!(run, state, result)
      run.update!(
        state:,
        response: JSON.generate(result),
        evidence_references: Array(result["evidence_references"] || result["evidence_refs"])
      )
    end
  end
end
