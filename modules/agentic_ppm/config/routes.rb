Rails.application.routes.draw do
  namespace :agentic_ppm do
    namespace :admin do
      resource :settings, only: %i[show update]
      resources :integration_connections, only: %i[create]
    end
  end

  scope "projects/:project_id" do
    get "agentic-ppm", to: "agentic_ppm/project_dashboard#show", as: :project_agentic_ppm
    post "agentic-ppm/agent-runs", to: "agentic_ppm/agent_runs#create", as: :project_agentic_ppm_agent_runs
    resources :agentic_ppm_rules, path: "agentic-ppm/rules", controller: "agentic_ppm/rules", only: %i[index create update] do
      post :transition, on: :member
    end
  end
end
