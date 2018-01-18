module Admin
  class CountriesController < ApplicationController
    before_action :require_login

    def new
      @countries = Country.all
      @country = Country.new
    end

    def edit
      @country = Country.find(params[:id])
    end

    def create
      @country = Country.new(country_params)
      if @country.save
        flash.notice = "#{@country.name} has been added to the list of serviced countries."
        redirect_to new_admin_country_path
      else
        flash.alert = @country.errors.full_messages
        @countries = Country.all
        render :new
      end
    end

    def update
      @country = Country.find(params[:id])
      @country.assign_attributes(country_params)
      if @country.save
        flash.notice = "#{@country.name} has been updated."
        redirect_to new_admin_country_path
      else
        flash.alert = @country.errors.full_messages
        render :edit
      end
    end

    def destroy
      country = Country.find(params[:id])
      country.destroy
      flash.alert = "#{country.name} has been removed."
      redirect_to new_admin_country_path
    end

    private

    def country_params
      params.require(:country)
        .permit(:name, :code)
    end
  end
end
