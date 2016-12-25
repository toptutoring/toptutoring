Rails.application.routes.draw do
  get "sign_in" => "sessions#new", as: nil
  get "/reset_password" => "passwords#new", as: "reset_password"
  get "/example_dashboard" => "pages#example_dashboard"
  get "/calendar" => "pages#calendar"
  post "payments/one_time" => "one_time_payments#create"
  get "/confirmation" => "one_time_payments#confirmation"

  # Omniauth routes
  get "/auth/dwolla/callback", to: "auth_callbacks#create"
  get "/auth/failure", to: "auth_callbacks#failure"

  #Clearance routes
  resource :session, controller: "sessions", only: [:new, :create]
  resources :payments, only: [:new, :create]

  constraints Clearance::Constraints::SignedIn.new { |user| user.parent? && user.customer? } do
    get "/payment" => "payments#new"
  end

  constraints Clearance::Constraints::SignedIn.new { |user| user.parent? } do
    get "/payment" => "one_time_payments#new"
  end

  root to: "sessions#new"
end
