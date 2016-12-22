Rails.application.routes.draw do
  root to: "sessions#new"
  get "/reset_password" => "passwords#new", as: "reset_password"
  get "/example_dashboard" => "pages#example_dashboard"
  get "/calendar" => "pages#calendar"
  get "payment" => "one_time_payments#new"
  post "payments/one_time" => "one_time_payments#create"
  get "/confirmation" => "one_time_payments#confirmation"

  # Omniauth routes
  get "/auth/dwolla/callback", to: "auth_callbacks#create"
  get "/auth/failure", to: "auth_callbacks#failure"
end
