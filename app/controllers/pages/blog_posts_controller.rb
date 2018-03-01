module Pages
  class BlogPostsController < ApplicationController
    layout "authentication"
    def index
      @posts = BlogPost.published
      @categories = BlogCategory.all
    end

    def show
      @post = BlogPost.published.find_by(slug: slug)
      render "www/pages/404", status: :not_found unless @post
    end

    private

    def slug
      params.require(:slug)
    end
  end
end
