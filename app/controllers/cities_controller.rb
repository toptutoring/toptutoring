class CitiesController < ApplicationController
  before_action :require_login

  def index
    @cities = City.all.includes(:country)
  end

  def show
    @city = City.find(params[:id]).includes(:country)
  end

  def new
    @city = City.new
    @countries = Country.all
  end

  def edit
    @city = City.find(params[:id])
    @countries = Country.all
  end

  def create
    @city = City.new(city_params)
    if @city.save
      flash.notice = "#{@city.name} has been added to the list of serviced cities."
      redirect_to cities_path
    else
      flash.alert = @city.errors.full_messages
      @countries = Country.all
      render :new
    end
  end

  def update
    @city = City.find(params[:id])
    @city.assign_attributes(city_params)
    if @city.save
      flash.notice = "#{@city.name} has been updated."
      redirect_to cities_path
    else
      flash.alert = @city.errors.full_messages
      @countries = Country.all
      render :edit
    end
  end

  def destroy
    city = City.find(params[:id])
    city.destroy
    flash.alert = "#{city.name} has been removed."
    redirect_to cities_path
  end

  private

  def city_params
    params.require(:city)
          .permit(:country_id, :name, :state, :phone_number, :description)
  end
end
