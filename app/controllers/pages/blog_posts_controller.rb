module Pages
  class BlogPostsController < ApplicationController
    layout "authentication"
    def index
      @posts = BlogPost.published.paginate(page: params[:page], per_page: 5)
    end

    def categories
      @posts = BlogPost.published
                       .includes(:blog_categories)
                       .where(blog_categories: { name: cat_name })
                       .paginate(page: params[:page], per_page: 5)
      render :index
    end

    def show
      @post = BlogPost.published.find_by!(slug: slug)
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
