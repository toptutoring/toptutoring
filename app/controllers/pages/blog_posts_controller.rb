module Pages
  class BlogPostsController < ApplicationController
    layout "authentication"
    def index
      @posts = BlogPost.published
    end

    def categories
      @posts = BlogPost.published
                       .joins(:blog_categories)
                       .where(blog_categories: { name: cat_name })
      render :index
    end

    def show
      @post = BlogPost.published.find_by(slug: slug)
      render "www/pages/404", status: :not_found unless @post
    end

    private

    def slug
      params.require(:slug)
    end

    def cat_name
      params.require(:name)
    end
  end
end
