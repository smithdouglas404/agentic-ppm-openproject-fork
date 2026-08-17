module OpenProject::AgenticPpm::Patches
  module ProjectPatch
    def self.included(base)
      base.class_eval do
        has_many :business_rules,
                 class_name: "AgenticPpm::BusinessRule",
                 dependent: :destroy,
                 inverse_of: :project
      end
    end
  end
end

Project.include OpenProject::AgenticPpm::Patches::ProjectPatch
