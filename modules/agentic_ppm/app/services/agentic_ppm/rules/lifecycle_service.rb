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
          published_at: target_state == "published" ? Time.current : rule.published_at
        )
        rule.save!
      end

      private

      attr_reader :rule, :actor

      def validate_publishable!
        raise ArgumentError, "An approved rule is required before publication" unless rule.state_approved?
        raise ArgumentError, "A visual flow reference is required before publication" if rule.visual_flow_reference.blank?
        raise ArgumentError, "A validation result marked valid is required before publication" unless rule.validation_result["valid"] == true
      end
    end
  end
end
