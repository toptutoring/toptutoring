module Pages
  class BlogPostsController < ApplicationController
    layout "authentication"
    def index
      @posts = BlogPost.published
                       .order(publish_date: :desc)
                       .paginate(page: params[:page], per_page: 5)
    end

    def categories
      cat = BlogCategory.find_by(name: cat_name)
      @posts = cat.blog_posts.published
                  .order(:publish_date)
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
