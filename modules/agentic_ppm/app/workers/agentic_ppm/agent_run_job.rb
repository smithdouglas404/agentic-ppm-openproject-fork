module AgenticPpm
  class AgentRunJob < ApplicationJob
    queue_as :default

    def perform(agent_run_id)
      run = AgentRun.find(agent_run_id)
      return if run.state.in?(%w[completed failed unavailable])

      run.update!(state: "running")
      result = Agents::RuntimeDispatchService.new(run:).call
      persist_result!(run, result)
      if result["status"] == "running" && result["job_id"].present?
        AgenticPpm::AgentRunPollJob.set(wait: 2.seconds).perform_later(run.id, result.fetch("job_id"))
      end
    rescue StandardError => error
      persist_failure!(run, error) if defined?(run) && run
      raise
    end

    private

    def persist_result!(run, result)
      run.update!(
        state: result.fetch("status", "running") == "complete" ? "completed" : "running",
        response: JSON.generate(result),
        evidence_references: evidence_references_from(result)
      )
    end

    def evidence_references_from(result)
      Array(
        result["evidence_references"] ||
        result["evidence_refs"] ||
        result.dig("output", "evidence_references") ||
        result.dig("output", "evidence_refs") ||
        result.dig("output", "finding", "evidence_references")
      )
    end

    def persist_failure!(run, error)
      run.update_columns(
        state: "failed",
        response: JSON.generate(
          "error" => "agent_runtime_failed",
          "error_class" => error.class.name,
          "message" => error.message.to_s.first(500)
        ),
        updated_at: Time.current
      )
    end
  end
end
