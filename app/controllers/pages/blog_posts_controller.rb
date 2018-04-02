module Pages
  class BlogPostsController < ApplicationController
    layout "authentication"
    def index
      @posts = BlogPost.published
                       .order(publish_date: :desc)
                       .paginate(page: params[:page], per_page: 5)
    end

    def show
      @post = BlogPost.published.find_by!(slug: slug)
    end

    private

    def slug
      params.require(:slug)
    end
  end
end
