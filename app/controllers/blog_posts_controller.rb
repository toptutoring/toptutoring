class BlogPostsController < ApplicationController
  # for now, only for admin/director/contractor
  before_action :require_login
  layout "authentication"

  def index
    @posts = BlogPost.all
  end

  def new
    @post = BlogPost.new
  end

  def edit
    @post = BlogPost.find(params[:id])
  end

  def show
    @post = BlogPost.find(params[:id])
  end

  def create
    @post = BlogPost.new(post_params)
    if @post.save
      flash.notice = "Post successfully created"
      redirect_to action: :show, id: @post.id
    else
      flash.alert = @post.errors.full_messages
      render :edit
    end
  end

  def update
    @post = BlogPost.find(params[:id])
    if @post.update(post_params)
      flash.notice = "Post successfully updated"
      redirect_to action: :show, id: @post.id
    else
      flash.alert = @post.errors.full_messages
      render :edit
    end
  end

  private

  def post_params
    params.require(:blog_post)
          .permit(:title, :publish_date, :content)
          .merge(user: current_user)
  end
end
