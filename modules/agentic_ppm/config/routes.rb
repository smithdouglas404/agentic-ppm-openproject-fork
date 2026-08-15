Rails.application.routes.draw do
  namespace :agentic_ppm do
    namespace :admin do
      resource :settings, only: %i[show update]
    end
  end

  scope "projects/:project_id" do
    get "agentic-ppm", to: "agentic_ppm/project_dashboard#show", as: :project_agentic_ppm
  end
end
