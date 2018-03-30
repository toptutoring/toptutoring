class TestTopTutoring
  def self.matches?(request)
    # Do not prepend "www" for now to
    # keep the domain as short as possible
    sub = request.subdomain
    splitter_leader(sub) == "test"
  end
end

Rails.application.routes.draw do
  constraints TestTopTutoring do
    get "/sign_in" => "sessions#new", as: "test_login"
    constraints Clearance::Constraints::SignedIn.new { |user| user.has_role?("admin") || user.has_role?("director") } do
      get "/test_sign_out" => "sessions#destroy"
      get "/*path" => "pages#show"
      root to: "pages#home"
    end
  end
end

class WwwTopTutoring
  def self.matches?(request)
    # Do not prepend "www" for now to
    # keep the domain as short as possible
    sub = request.subdomain
    splitter_leader(sub).blank? || sub.match("toptutoring-staging")
  end
end

Rails.application.routes.draw do
  constraints WwwTopTutoring do
    namespace :pages, path: "" do
      resources :tutors, path: "top-tutors", param: :first_name, only: [:index, :show]
      get "/blog/categories/:name" => "blog_posts#categories", as: "blog_categories"
      resources :blog_posts, path: "blog", param: :slug, only: [:index, :show]
    end
    get "/*path" => "pages#show"
    root to: "pages#home"
  end
end
