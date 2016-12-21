Rails.application.routes.draw do
  root to: "sessions#new"
  get "/reset_password" => "passwords#new", as: "reset_password"
  get "/example_dashboard" => "pages#example_dashboard"
  get "/calendar" => "pages#calendar"
end
