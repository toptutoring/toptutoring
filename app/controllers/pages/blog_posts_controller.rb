module Pages
  class BlogPostsController < ApplicationController
    layout "authentication"
    def index
      @posts = BlogPost.published
                       .order(publish_date: :desc)
                       .paginate(page: params[:page], per_page: 5)
      @page_title = "Top Tutoring | Blog"
    end

    def show
      @post = BlogPost.published.find_by!(slug: slug)
      @page_title = @post.title
    end

    private

    def slug
      params.require(:slug)
    end
  end
end
