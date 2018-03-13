class Admin::Blogs::BlogPostsController < ApplicationController
  # for now, only for admin/director/contractor
  before_action :require_login
  before_action :set_post, only: [:show, :edit]
  layout "authentication"

  def index
    @posts = BlogPost.all.order(publish_date: :desc)
    render layout: "application"
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

  def publish
    @post = BlogPost.find(params[:id])
    if @post.update(draft: draft?)
      flash.notice = "Post has been updated."
    else
      flash.alert = "Post could not be updated."
    end
    redirect_to action: :index
  end

  private

  def post_params
    params.require(:blog_post)
          .permit(:title, :publish_date, :excerpt, :content,
                  :draft, blog_category_ids: [])
          .merge(user: current_user)
  end

  def wrap_up(action)
    flash.notice = "Post successfully #{action}"
    redirect_to action: :show, id: @post.id
  end

  def failed_save
    flash.now[:alert] = @post.errors.full_messages
    render :edit
  end

  def draft?
    params.require(:draft)
  end

  def set_post
    @post = BlogPost.find(params[:id])
  end
end
