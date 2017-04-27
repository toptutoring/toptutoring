require "sidekiq/web"

Rails.application.routes.draw do
  get "/sign_in" => "sessions#new", as: "login"
  get "/reset_password" => "passwords#new", as: "reset_password"
  post "/passwords" => "passwords#create"
  get "/example_dashboard" => "pages#example_dashboard"
  get "/calendar" => "pages#calendar"
  get "/one_time_payment" => "one_time_payments#new"
  post "/payments/one_time" => "one_time_payments#create"
  get "/confirmation" => "one_time_payments#confirmation"
  get "payment" => "pages#payment"

  # Omniauth routes
  get "/auth/dwolla/callback", to: "auth_callbacks#create"
  get "/auth/failure", to: "auth_callbacks#failure"

  #Clearance routes
  resource :session, controller: "sessions", only: [:new, :create]
  resources :payments, only: [:new, :create, :index]

  constraints Clearance::Constraints::SignedIn.new { |user| user.has_role?("admin") } do
    namespace :admin do
      resources :users, only: [:index, :edit, :update]
    end 
    mount Sidekiq::Web, at: '/sidekiq'
    get "/dashboard" => "dashboards#admin"
  end

  constraints Clearance::Constraints::SignedIn.new { |user| user.has_role?("director") } do
    get "/dashboard" => "dashboards#director"
    namespace :director do 
      resources :payments, only: [:new, :create, :index]
      resources :tutors, only: [:index, :edit, :update]
    end
  end

  constraints Clearance::Constraints::SignedIn.new { |user| user.has_role?("admin") || user.has_role?("director") } do
    namespace :admin do
      resources :payments, only: [:new, :create, :index]
      resources :invoices, only: [:index]
      resources :tutors, only: [:index, :edit, :update]
      resources :funding_sources, only: [:new, :create, :edit, :update]
      resources :emails, only: [:index]
    end
  end

  constraints Clearance::Constraints::SignedIn.new { |user| user.has_role?("tutor") } do
    get "/dashboard" => "dashboards#tutor"
    namespace :tutors do
      resources :students, only: [:index]
      resources :invoices, only: [:index, :create]
      resources :emails, only: [:index]
    end
    resources :users do
      member do
        resources :emails, only: [:new, :create]
      end
    end
  end

  constraints Clearance::Constraints::SignedIn.new { |user| user.has_role?("client") } do
    get "/payment/new" => "payments#new"
    get "/one_time_payment" => "one_time_payments#new"
    post "/payments/one_time" => "one_time_payments#create"
    get "/confirmation" => "one_time_payments#confirmation"
    resources :students, only: [:index, :new, :create]
    get "/dashboard" => "dashboards#client"
  end

  constraints Clearance::Constraints::SignedIn.new { |user| user.has_role?("student") } do
    get "/dashboard" => "dashboards#student"
  end

  # API
  namespace :api do
    namespace :signups, defaults: { format: 'json' } do
      resources :users, only: :create
      match '/users' => "users#create", via: :options
      resources :tutors, only: :create
      match '/tutors' => "tutors#create", via: :options
    end
  end

  # Users
  resources :users, only: [:edit, :update]

  # Users signup.
  namespace :users do
    resources :clients, only: [:new, :create]
    resources :tutors, only: [:new, :create]
  end

  resources :engagements do
    member do
      get '/enable' => "engagements#enable"
      get '/disable' => "engagements#disable"
    end
  end

  # Demo dashboards
  get "/tutor-dashboard" => "pages#tutor_dashboard"
  get "/director-dashboard" => "pages#director_dashboard"
  get "/admin-dashboard" => "pages#admin_dashboard"


  root to: "sessions#new"
end
