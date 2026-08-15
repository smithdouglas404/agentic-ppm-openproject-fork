module OpenProject
  module AgenticPpm
    class Engine < ::Rails::Engine
      engine_name :openproject_agentic_ppm

      include OpenProject::Plugins::ActsAsOpEngine

      register "openproject-agentic_ppm",
               bundled: true,
               author_url: "https://github.com/smithdouglas404/agentic-ppm-openproject-fork" do
        project_module :agentic_ppm, dependencies: :work_package_tracking do
          permission :view_agentic_ppm,
                     { "agentic_ppm/project_dashboard" => %i[show] },
                     permissible_on: :project
          permission :run_agentic_ppm_agents,
                     { "agentic_ppm/agent_runs" => %i[create] },
                     permissible_on: :project
          permission :manage_agentic_ppm,
                     { "agentic_ppm/project_settings" => %i[show update] },
                     permissible_on: :project
          permission :manage_agentic_ppm_rules,
                     { "agentic_ppm/rules" => %i[index create update publish rollback] },
                     permissible_on: :project
          permission :manage_agentic_ppm_integrations,
                     { "agentic_ppm/integrations" => %i[index create update sync] },
                     permissible_on: :project
        end

        permission :administer_agentic_ppm,
                   { "agentic_ppm/admin/settings" => %i[show update] },
                   permissible_on: :global

        menu :project_menu,
             :agentic_ppm,
             { controller: "/agentic_ppm/project_dashboard", action: :show },
             after: :overview,
             caption: :label_agentic_ppm,
             icon: "op-graph",
             if: ->(project) { project.module_enabled?(:agentic_ppm) }

        menu :admin_menu,
             :agentic_ppm,
             { controller: "/agentic_ppm/admin/settings", action: :show },
             parent: :api_and_webhooks,
             caption: :label_agentic_ppm,
             if: -> { User.current.admin? }
      end
    end
  end
end
