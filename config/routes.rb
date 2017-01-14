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
    get "/dashboard" => "dashboards#admin"
  end

  constraints Clearance::Constraints::SignedIn.new { |user| user.director? } do
    get "/dashboard" => "pages#director_dashboard"
  end

  constraints Clearance::Constraints::SignedIn.new { |user| user.tutor? } do
    get "/dashboard" => "pages#tutor_dashboard"
  end

  constraints Clearance::Constraints::SignedIn.new { |user| user.parent? && user.customer? } do
    get "/payment/new" => "payments#new"
  end

  constraints Clearance::Constraints::SignedIn.new { |user| user.parent? } do
    get "/payment/new" => "one_time_payments#new"
  end

  # API
  namespace :api do
    namespace :signups do
      resources :users, only: :create
      match '/users' => "users#create", via: :options
      resources :tutors, only: :create
      match '/tutors' => "tutors#create", via: :options
    end
  end

  # Users
  resources :users, only: [:edit, :update]
  resources :assignments

  # Demo dashboards
  get "/tutor-dashboard" => "pages#tutor_dashboard"
  get "/director-dashboard" => "pages#director_dashboard"
  get "/admin-dashboard" => "pages#admin_dashboard"


  root to: "sessions#new"
end
