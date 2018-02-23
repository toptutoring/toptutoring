class WwwTopTutoring
  def self.matches?(request)
    # Do not prepend 'www' for now to
    # keep the domain as short as possible
    splitter_leader(request.subdomain).blank?
  end
end

def splitter_leader(subdomain)
  subdomain.try(:split, '.').try(:first)
end

Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  constraints WwwTopTutoring do
    namespace :pages, path: '' do
      resources :blog_posts, path: "blog", param: :slug, only: [:index, :show]
    end
    get "/*path" => "pages#show"
    root to: "pages#home"
  end
end
