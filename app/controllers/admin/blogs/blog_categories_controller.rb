class Admin::Blogs::BlogCategoriesController < ApplicationController
  # for now, only for admin/director/contractor
  before_action :require_login
  before_action :set_post, only: [:show, :edit]
  layout "authentication"

  def index
    @categories = BlogCategory.all
  end

  def create
    @category = BlogCategory.new(name: category_params)
    if @category.save
      flash.now[:notice] = "#{@category.name} has been added."
    else
      flash.now[:alert] = "#{@category.name} could not be added."
    end
  end

  def update
  end

  private

  def category_params
    params.require(:category_name)
  end
end
