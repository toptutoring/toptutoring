module Pages
  module Blog
    class CategoriesController < ApplicationController
      layout "authentication"
      def index
        redirect_to pages_blog_posts_path
      end

      def show
        cat = BlogCategory.find_by!(name: cat_name)
        @posts = cat.blog_posts.published
                    .order(:publish_date)
                    .paginate(page: params[:page], per_page: 5)
        @page_title = "Top Tutoring | Blog | #{cat.name}"
        render "pages/blog_posts/index"
      end

      private

      def cat_name
        params.require(:name)
      end
    end
  end
end
