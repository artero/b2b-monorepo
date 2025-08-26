Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  # DeviseTokenAuth routes for CustomerUser API authentication with custom controllers
  mount_devise_token_auth_for "CustomerUser", at: "auth", controllers: {
    sessions: "auth/sessions",
    token_validations: "auth/token_validations"
  }

  # Custom password generation routes (outside of Devise)
  resource :generate_passwords, controller: "customer_users/generate_passwords", only: [ :edit, :update, :show ]
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Custom health check with database verification
  get "health" => "health#index", as: :health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # API routes
  namespace :api do
    get "articles", to: "articles#index"
    resources "orders", only: [ :index, :create ]
  end

  # Defines the root path route ("/")
  root "admin/dashboard#index"

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
