module AgenticPpm
  module ServiceAdapters
    class NativeWorkflowAdapter < BaseAdapter
      def initialize
        super(name: :durable_workflow, enabled_environment_key: "AGENTIC_PPM_DURABLE_WORKFLOW_ENABLED")
      end
    end
  end
end
