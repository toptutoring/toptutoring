class Admin::Blogs::BlogCategoriesController < ApplicationController
  before_action :require_login

  def index
    @categories = BlogCategory.all.order("LOWER(name)")
  end

  def create
    @category = BlogCategory.new(name: category_params)
    if @category.save
      flash.notice = "#{@category.name} has been added."
    else
      flash.alert = "#{@category.name} could not be added."
    end
    redirect_to action: :index
  end

  def form_create
    @category = BlogCategory.new(name: category_params)
    if @category.save
      flash.now[:notice] = "#{@category.name} has been added."
    else
      flash.now[:alert] = "#{@category.name} could not be added."
    end
  end

  def update
    @category = BlogCategory.find(params[:id])
    @updated = @category.update(name: category_params)
    flash.now[:alert] = @category.errors.full_messages unless @updated
  end

  def destroy
    @category = BlogCategory.find(params[:id])
    if @category.destroy
      flash.now[:notice] = "#{@category.name} has been removed."
    else
      flash.now[:alert] = "#{@category.name} could not be added."
    end
  end

  private

  def category_params
    params.require(:category_name)
  end
end
