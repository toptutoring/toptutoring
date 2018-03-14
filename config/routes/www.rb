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
      get "/blog/categories/:name" => "blog_posts#categories", as: "blog_categories"
      resources :blog_posts, path: "blog", param: :slug, only: [:index, :show]
    end
    get "/*path" => "pages#show"
    root to: "pages#home"
  end
end
