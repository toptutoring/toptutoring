Toptutoring::Application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }, path: '',
   path_names: { sign_in: 'login', sign_out: 'logout'}

  root 'pages#index'

  get "/index.html" => "pages#index"
  get "/contact" => "pages#contact"
  get "/login" => "pages#login"
  get "/contactsubmit" => "pages#contactsubmit"
  get "/about-us" => "pages#about-us"
  get "/New_SAT_2016.html" => "pages#New_SAT_2016"
  get "/New_SAT_Writing.html" => "pages#New_Sat_Writing"
  get "/services.html" => "pages#services"

  resource :payments, only: [:new, :create]
  get "payment" => "one_time_payments#new"
  post "payments/one_time" => "one_time_payments#create"
  get "/confirmation" => "payments#confirmation"

  devise_scope :user do
    get "/users/:user_id" => "registrations#show", :as => :user
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
