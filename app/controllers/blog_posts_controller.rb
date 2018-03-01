class BlogPostsController < ApplicationController
  # for now, only for admin/director/contractor
  before_action :require_login
  before_action :set_post, only: [:show, :edit]
  layout "authentication"

  def index
    @posts = BlogPost.all
  end

  def new
    @post = BlogPost.new
  end

  def create
    @post = BlogPost.new(post_params)
    if @post.save
      wrap_up("created")
    else
      failed_save
    end
  end

  def update
    @post = BlogPost.find(params[:id])
    if @post.update(post_params)
      wrap_up("updated")
    else
      failed_save
    end
  end

  private

  def post_params
    params.require(:blog_post)
      .permit(:title, :publish_date, :excerpt, :content)
      .merge(user: current_user)
  end

  def category_ids
    params.fetch(:post, {}).permit(categories: [])[:categories]
  end

  def wrap_up(action)
    @post.blog_category_ids = category_ids
    flash.notice = "Post successfully #{action}"
    redirect_to action: :show, id: @post.id
  end

  def failed_save
    flash.now[:alert] = @post.errors.full_messages
    render :edit
  end

  def set_post
    @post = BlogPost.find(params[:id])
  end
end
