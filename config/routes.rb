require "sidekiq/web"
require 'router/subdomain_builder'
require_relative "routes/app"

class WwwTopTutoring
  def self.matches?(request)
    # Do not prepend "www" for now to
    # keep the domain as short as possible
    sub = request.subdomain
    splitter_leader(sub).blank? || sub.match("toptutoring-staging")
  end
end

def splitter_leader(subdomain)
  subdomain.try(:split, ".").try(:first)
end

Rails.application.routes.draw do
  mount Ckeditor::Engine => "/ckeditor"
  application_routes
  constraints WwwTopTutoring do
    namespace :pages, path: "" do
      resources :blog_posts, path: "blog", param: :slug, only: [:index, :show]
    end
    get "/*path" => "pages#show"
    root to: "pages#home"
  end
end
