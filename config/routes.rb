require "sidekiq/web"

Rails.application.routes.draw do
  get "/sign_in" => "sessions#new", as: "login"
  get "/reset_password" => "passwords#new", as: "reset_password"
  post "/passwords" => "passwords#create"
  get "/example_dashboard" => "pages#example_dashboard"
  get "/calendar" => "pages#calendar"
  get "/payment" => "one_time_payments#new"
  post "/payments/one_time" => "one_time_payments#create"
  get "/confirmation" => "one_time_payments#confirmation"

  # Omniauth routes
  get "/auth/dwolla/callback", to: "auth_callbacks#create"
  get "/auth/failure", to: "auth_callbacks#failure"

  #Clearance routes
  resource :session, controller: "sessions", only: [:new, :create]
  resources :payments, only: [:new, :create]

  constraints Clearance::Constraints::SignedIn.new { |user| user.admin? } do
    mount Sidekiq::Web, at: '/sidekiq'
    namespace :admin do
      resources :payments, only: [:new, :create, :index]
    end
    get "/dashboard" => "pages#admin_dashboard"
  end

  constraints Clearance::Constraints::SignedIn.new { |user| user.director? } do
    get "/dashboard" => "pages#director_dashboard"
  end

  constraints Clearance::Constraints::SignedIn.new { |user| user.tutor? } do
    get "/dashboard" => "pages#tutor_dashboard"
  end

  constraints Clearance::Constraints::SignedIn.new { |user| user.parent? && user.customer? } do
    get "/payment" => "payments#new"
  end

  constraints Clearance::Constraints::SignedIn.new { |user| user.parent? } do
    get "/payment" => "one_time_payments#new"
  end

  # API
  namespace :api do
    namespace :signups do
      resources :users, only: :create
      resources :tutors, only: :create
    end
  end

  root to: "sessions#new"
end
