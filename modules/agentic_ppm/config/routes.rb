Rails.application.routes.draw do
  namespace :agentic_ppm do
    namespace :admin do
      resource :settings, only: %i[show update]
      resources :integration_connections, only: %i[create]
    end
  end

  scope "projects/:project_id" do
    get "agentic-ppm", to: "agentic_ppm/project_dashboard#show", as: :project_agentic_ppm
    get "agentic-ppm/api/dashboard", to: "agentic_ppm/dashboard_api#show", as: :project_agentic_ppm_dashboard_api
    get "agentic-ppm/api/graph", to: "agentic_ppm/graph_api#show", as: :project_agentic_ppm_graph_api
    get "agentic-ppm/api/entities/:entity_key", to: "agentic_ppm/entity_api#show", as: :project_agentic_ppm_entity_api
    get "agentic-ppm/api/observability", to: "agentic_ppm/observability_api#show", as: :project_agentic_ppm_observability_api
    get "api/v1/agentic-ppm/observability", to: "agentic_ppm/observability_api#show", as: :project_agentic_ppm_v1_observability_api
    get "api/v1/agentic-ppm/entities/:entity_key", to: "agentic_ppm/entity_api#show", as: :project_agentic_ppm_v1_entity_api
    get "api/v1/agentic-ppm/graph", to: "agentic_ppm/graph_api#show", as: :project_agentic_ppm_v1_graph_api
    get "agentic-ppm/conversations", to: "agentic_ppm/agent_conversations#show", as: :project_agentic_ppm_conversations
    get "agentic-ppm/agent-runs", to: "agentic_ppm/agent_runs#index", as: :project_agentic_ppm_agent_runs
    post "agentic-ppm/agent-runs", to: "agentic_ppm/agent_runs#create", as: :project_agentic_ppm_agent_runs
    get "agentic-ppm/agent-runs/:id", to: "agentic_ppm/agent_runs#show", as: :project_agentic_ppm_agent_run
    get "api/v1/agentic-ppm/agent-runs", to: "agentic_ppm/agent_runs#index", as: :project_agentic_ppm_v1_agent_runs
    post "api/v1/agentic-ppm/agent-runs", to: "agentic_ppm/agent_runs#create", as: :project_agentic_ppm_v1_agent_runs_create
    get "api/v1/agentic-ppm/agent-runs/:id", to: "agentic_ppm/agent_runs#show", as: :project_agentic_ppm_v1_agent_run
    post "agentic-ppm/findings/:id/review", to: "agentic_ppm/findings#review", as: :project_agentic_ppm_finding_review
    post "api/v1/agentic-ppm/findings/:id/review", to: "agentic_ppm/findings#review", as: :project_agentic_ppm_v1_finding_review
    resources :agentic_ppm_rules, path: "agentic-ppm/rules", controller: "agentic_ppm/rules", only: %i[index create update] do
      post :transition, on: :member
      post :validate, on: :member
      post :simulate, on: :member
    end
  end

  scope "api/v1/projects/:project_id/agentic-ppm" do
    get "dashboard", to: "agentic_ppm/dashboard_api#show", as: :api_v1_project_agentic_ppm_dashboard
    get "graph", to: "agentic_ppm/graph_api#show", as: :api_v1_project_agentic_ppm_graph
    get "entities/:entity_key", to: "agentic_ppm/entity_api#show", as: :api_v1_project_agentic_ppm_entity
    get "agent-runs", to: "agentic_ppm/agent_runs#index", as: :api_v1_project_agentic_ppm_agent_runs
    post "agent-runs", to: "agentic_ppm/agent_runs#create", as: :api_v1_project_agentic_ppm_agent_runs_create
    get "agent-runs/:id", to: "agentic_ppm/agent_runs#show", as: :api_v1_project_agentic_ppm_agent_run
    post "findings/:id/approve", to: "agentic_ppm/findings#review", defaults: { status: "approved" }, as: :api_v1_project_agentic_ppm_finding_approve
    post "findings/:id/review", to: "agentic_ppm/findings#review", as: :api_v1_project_agentic_ppm_finding_review
    get "rules", to: "agentic_ppm/rules#index", as: :api_v1_project_agentic_ppm_rules
    post "rules", to: "agentic_ppm/rules#create", as: :api_v1_project_agentic_ppm_rules_create
    patch "rules/:id", to: "agentic_ppm/rules#update", as: :api_v1_project_agentic_ppm_rule
    get "observability", to: "agentic_ppm/observability_api#show", as: :api_v1_project_agentic_ppm_observability
  end
end
