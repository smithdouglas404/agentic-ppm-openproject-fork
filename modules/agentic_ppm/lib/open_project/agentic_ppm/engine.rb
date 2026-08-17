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
                     {
                       "agentic_ppm/agent_runs" => %i[create],
                       "agentic_ppm/agent_conversations" => %i[show]
                     },
                     permissible_on: :project
          permission :manage_agentic_ppm,
                     { "agentic_ppm/project_settings" => %i[show update] },
                     permissible_on: :project
          permission :manage_agentic_ppm_rules,
                     { "agentic_ppm/rules" => %i[index create update transition] },
                     permissible_on: :project
          permission :manage_agentic_ppm_integrations,
                     { "agentic_ppm/integrations" => %i[index create update sync] },
                     permissible_on: :project
          permission :administer_agentic_ppm,
                     {
                       "agentic_ppm/admin/settings" => %i[show update],
                       "agentic_ppm/admin/integration_connections" => %i[create]
                     },
                     permissible_on: :global
        end

        menu :project_menu,
             :agentic_ppm,
             { controller: "/agentic_ppm/project_dashboard", action: :show },
             after: :overview,
             caption: :label_agentic_ppm,
             icon: "op-boards",
             if: ->(project) { project.module_enabled?(:agentic_ppm) }

        menu :project_menu,
             :agentic_ppm_rules,
             { controller: "/agentic_ppm/rules", action: :index },
             after: :agentic_ppm,
             caption: :agentic_ppm_business_rules,
             icon: "note",
             if: ->(project) { project.module_enabled?(:agentic_ppm) && User.current.allowed_in_project?(:manage_agentic_ppm_rules, project) }

        menu :project_menu,
             :agentic_ppm_conversations,
             { controller: "/agentic_ppm/agent_conversations", action: :show },
             after: :agentic_ppm,
             caption: :agentic_ppm_conversation_workspace,
             icon: "chat",
             if: ->(project) { project.module_enabled?(:agentic_ppm) && User.current.allowed_in_project?(:run_agentic_ppm_agents, project) }

        menu :admin_menu,
             :agentic_ppm,
             { controller: "/agentic_ppm/admin/settings", action: :show },
             parent: :api_and_webhooks,
             caption: :label_agentic_ppm,
             if: -> { User.current.admin? }
      end

      patches %i[Project]
    end
  end
end
