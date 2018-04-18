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
    resources :leads, only: :create
    namespace :pages, path: "" do
      resources :tutors, path: "top-tutors", param: :first_name, only: [:index, :show]
      namespace :blog do
        resources :categories, param: :name, only: [:index, :show]
      end
      resources :blog_posts, path: "blog", param: :slug, only: [:index, :show]
    end
    get "/:slug" => "cities#show", param: :slug, constraints: { slug: /(\w+-)+tutoring/ }
    get "/*path" => "pages#show"
    root to: "pages#home"
  end
end
