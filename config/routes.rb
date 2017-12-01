class WwwTopTutoring
  def self.matches?(request)
    splitter_leader(request.subdomain) == "www"
  end
end

def splitter_leader(subdomain)
  subdomain.try(:split, '.').try(:first)
end

Rails.application.routes.draw do
  constraints WwwTopTutoring do
    root to: "pages#home"
  end
end
