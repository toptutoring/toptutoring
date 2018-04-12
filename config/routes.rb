require "sidekiq/web"
require 'router/subdomain_builder'

def splitter_leader(subdomain)
  subdomain.try(:split, ".").try(:first)
end

class AppTopTutoring
  def self.matches?(request)
    sub = request.subdomain
    splitter_leader(sub) == "app" || sub.match("toptutoring-staging")
  end
end

Rails.application.routes.draw do
  mount Ckeditor::Engine => "/ckeditor"
  constraints AppTopTutoring do
    mount Sidekiq::Web, at: '/sidekiq' if Rails.env.development?
    get "/sign_in" => "sessions#new", as: "login"
    get "/payments/one_time" => "one_time_payments#new", as: "one_time_payment"
    post "/payments/one_time" => "one_time_payments#create"
    get "/confirmation" => "one_time_payments#confirmation"

    # review routes
    get ":unique_token/rate_us" => "reviews#new", as: "new_review"
    post ":unique_token/rate_us" => "reviews#create", as: "create_review"

    # Client Signups
    get "/sign_up" => "users/clients#new", as: "client_sign_up"
    post "/sign_up" => "users/clients#create", as: :users_clients

    resource :password, only: [:create, :edit]
    get "/reset_password" => "passwords#new", as: "reset_password"

    # Omniauth routes
    get "/auth/:provider/setup", to: "auth_setup#setup"
    get "/auth/:provider/callback", to: "auth_callbacks#create"
    get "/auth/failure", to: "auth_callbacks#failure"
    post "/dwolla/webhooks", to: "webhooks/dwolla#update"

    #Clearance routes
    resource :session, controller: "sessions", only: [:new, :create]

    resources :cities, only: [:show]

    scope module: "admin" do
      resources :users, only: [] do
        resource :masquerade, only: :create
      end
      resource :masquerade, only: :destroy
    end

    resource :profile, only: [:edit, :show, :update]

    constraints Clearance::Constraints::SignedIn.new { |user| user.has_role?("admin") } do
      namespace :admin do
        resources :users, only: [:index, :edit, :destroy, :update] do
          patch :reactivate, on: :member
          patch :archive, on: :member
        end
        resources :timesheets
        resources :roles
        resources :subjects do
          patch :switch_category, on: :member
          patch :update_name, on: :member
        end
        namespace :payments do
          resource :miscellaneous_payment, only: [:new, :create]
        end
      end
      resources :open_tok_rooms
      mount Sidekiq::Web, at: "/sidekiq" unless Rails.env.development?
      get "/dashboard" => "dashboards#admin"
    end

    constraints Clearance::Constraints::SignedIn.new { |user| user.has_role?("director") } do
      get "/dashboard" => "dashboards#director"
      namespace :director do
        resources :payments, only: [:index]
        resources :users, only: [:index, :edit, :update] do
          patch :archive, on: :member
        end
      end
    end

    constraints Clearance::Constraints::SignedIn.new { |user| user.has_role?("admin") || user.has_role?("director") } do
      scope module: :admin do
        scope module: :blogs do
          resources :blog_posts do
            get :publish, on: :member
          end
          resources :blog_categories
        end
      end
      namespace :admin do
        resources :tutors, only: [:index, :show, :edit, :update] do
          patch :reactivate, on: :member, controller: :users
          patch :archive, on: :member, controller: :users
        end
        resources :tutor_accounts do
          patch "badge" =>"tutor_accounts#badge"
        end
        resources :payments, only: [:new, :create, :index]
        resources :invoices, only: [:index, :edit, :update] do
          patch :deny, on: :member
        end
        resources :funding_sources, only: [:new, :create, :edit, :update]
        resources :emails, only: [:index]
        namespace :payments do
          resources :pay_all
        end
        resources :feedbacks, only: [:index]
        resources :client_reviews
        resources :cities do
          member do
            post "/publish" => "cities#publish"
            get "/preview" => "cities#preview"
          end
        end
        resources :countries
      end
      resources :engagements do
        member do
          get "/enable" => "engagements#enable"
          get "/disable" => "engagements#disable"
        end
      end
    end

    constraints Clearance::Constraints::SignedIn.new { |user| user.has_role?("tutor") } do
      get "/dashboard" => "dashboards#tutor"
      namespace :tutors do
        resources :students, only: [:index]
        resources :invoices, only: [:index, :create, :destroy]
        resources :emails, only: [:index]
        resources :subjects, only: [:index, :update]
        resource :tutor_profile, only: [:show, :update]
        scope :tutor_profile do
          post "profile_picture" => "tutor_profiles#post_picture", as: :add_profile_picture
          delete "profile_picture" => "tutor_profiles#remove_picture", as: :remove_profile_picture
        end
        resources :test_scores, only: [:create, :destroy, :update]
      end
      resources :users do
        member do
          resources :emails, only: [:new, :create]
        end
      end
    end

    constraints Clearance::Constraints::SignedIn.new { |user| user.has_role?("client") } do
      namespace :clients do
        resources :payments, only: [:new, :create]
        resources :students, only: [:show, :edit, :index, :new, :create]
        resources :invoices, only: [:index]
        resources :tutors
        resource :request_tutor, only: [:destroy, :new, :create]
        resources :payment_methods
      end
      get "/dashboard" => "dashboards#client"
      resources :availability, only: [:new, :create, :update, :edit]
      post "/availability/dropdown_change" => "availability#dropdown_change"
      post "/dashboard/feedback" => "feedback#create"
    end

    constraints Clearance::Constraints::SignedIn.new { |user| user.has_role?("student") } do
      get "/dashboard" => "dashboards#student"
      resources :availability, only: [:new, :create, :update, :edit]
      post "/availability/dropdown_change" => "availability#dropdown_change"
    end

    constraints Clearance::Constraints::SignedIn.new { |user| user.has_role?("contractor") } do
      get "/dashboard" => "dashboards#contractor"
      namespace :tutors do
        resources :invoices, only: [:index, :create, :destroy]
      end
      resources :open_tok_rooms
      resources :timesheets
    end

    # API
    namespace :api do
      namespace :signups, defaults: { format: "json" } do
        resources :users, only: :create
        match "/users" => "users#create", via: :options
        resources :tutors, only: :create
        match "/tutors" => "tutors#create", via: :options
      end
    end

    # Users
    resources :users, only: [:edit, :update]
    resources :referrals, param: :unique_token, module: "users", only: [:show, :create]

    # Tutor signup.
    namespace :users do
      resources :tutors, only: [:new, :create]
      get "tutors/signup" => "tutors#signup"
    end

    root "sessions#new"
  end
end
