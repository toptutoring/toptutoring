class AvailabilityController < ApplicationController

  DAYS = %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday)
  DAYS_IN_A_WEEK = 7

  def new
    @days = DAYS
    @availabilities = []
    DAYS_IN_A_WEEK.times do
      @availabilities << Availability.new
    end
    @engagements = Engagement.where(client_id: current_user.id)
  end

  def create

    availabilityCreator = AvailabilityCreator.new(availability_params, [])
    availabilityCreator.create_availabilities

    flash[:notice] = "Your submission for availability was successful."
    redirect_to profile_path
  end

  def edit
    @days = DAYS
    @availabilities = current_user&.student_engagements&.first&.availabilities || current_user&.client_engagements&.first&.availabilities
    @engagements = Engagement.where(client_id: current_user.id)
  end

  def update

    @availabilities = (Availability.find(params[:id])).engagement.availabilities
    availabilityCreator = AvailabilityCreator.new(availability_params, @availabilities)
    availabilityCreator.update_availabilities

    flash[:notice] = "Your availability was successfully updated."
    redirect_to profile_path
  end

  private

  def availability_params
    return params.require(:info).permit(permit_symbols_for_availability_params, :current_engagement)
  end

  def permit_symbols_for_availability_params
    permit_strings = []

    7.times do |count|
      permit_strings << "#{DAYS[count]}_from"
      permit_strings << "#{DAYS[count]}_to"
      permit_strings << "#{DAYS[count]}_from_am_pm"
      permit_strings << "#{DAYS[count]}_to_am_pm"
    end

    permit_symbols = permit_strings.map &:to_sym
    return permit_symbols
  end
end
