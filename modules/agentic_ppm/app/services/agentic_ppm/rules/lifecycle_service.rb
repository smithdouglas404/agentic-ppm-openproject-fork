module AgenticPpm
  module Rules
    class LifecycleService
      TRANSITIONS = {
        "draft" => %w[submitted archived],
        "submitted" => %w[approved draft archived],
        "approved" => %w[published draft archived],
        "published" => %w[rolled_back archived],
        "rolled_back" => %w[draft archived],
        "archived" => []
      }.freeze

      def initialize(rule:, actor:)
        @rule = rule
        @actor = actor
      end

      def transition_to!(target_state)
        target_state = target_state.to_s
        raise ArgumentError, "Invalid rule lifecycle transition" unless TRANSITIONS.fetch(rule.state).include?(target_state)

        validate_publishable! if target_state == "published"
        rule.assign_attributes(
          state: target_state,
          approved_by: target_state == "approved" ? actor : rule.approved_by,
          published_at: target_state == "published" ? Time.current : rule.published_at,
          last_transition_at: Time.current,
          authorization_decision: {
            "project_id" => rule.project_id,
            "rule_id" => rule.id,
            "actor_id" => actor.id,
            "state_transition" => "#{rule.state}->#{target_state}",
            "flow_reference" => rule.visual_flow_reference,
            "flow_version" => rule.validation_result.to_h["flow_version"],
            "validation_result_reference" => rule.validation_result_reference,
            "authorized" => true,
            "observed_at" => Time.current.iso8601
          }
        )
        rule.save!
      end

      private

      attr_reader :rule, :actor

      def validate_publishable!
        raise ArgumentError, "An approved rule is required before publication" unless rule.state_approved?
        raise ArgumentError, "A visual flow reference is required before publication" if rule.visual_flow_reference.blank?
        raise ArgumentError, "A validation result marked valid is required before publication" unless rule.validation_result.to_h["valid"] == true
        raise ArgumentError, "A valid simulation trace is required before publication" unless rule.simulation_trace.to_h["valid"] == true
      end
    end
  end
end
