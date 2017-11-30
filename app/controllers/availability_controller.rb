class AvailabilityController < ApplicationController

  DAYS = %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday)
  DAYS_IN_A_WEEK = 7

  def new
    @days = DAYS
    @engagements = current_user.engagements
    @next_engagement = Engagement.find_by(id: params[:engagement_id])
    if @next_engagement.nil?
      @availabilities = []
      DAYS_IN_A_WEEK.times do
        @availabilities << Availability.new
      end
    else
      @availabilities = @next_engagement.availabilities
      if @availabilities.empty?
        @availabilities = []
        DAYS_IN_A_WEEK.times do
          @availabilities << Availability.new
        end
        @engagements = @engagements.to_a
        put_next_engagement_at_front(@engagements, @next_engagement)
      else
        redirect_to edit_availability_path(id: @next_engagement.availabilities.first.id, engagement_id: @next_engagement.id)
      end
    end
  end

  def create
    availabilityCreator = AvailabilityCreator.new(availability_params, [])
    availabilityCreator.create_availabilities

    flash[:notice] = "Your submission for availability was successful."
    redirect_to profile_path
  end

  def edit
    @days = DAYS
    @engagements = Engagement.where(client_id: current_user.id)
    @next_engagement = Engagement.find_by(id: params[:engagement_id])
    if @next_engagement.nil?
      @availabilities = current_availabilities
    else
      @availabilities = @next_engagement.availabilities
      if @availabilities.empty?
        redirect_to new_availability_path(engagement_id: @next_engagement.id)
      end
      @engagements = @engagements.to_a
      put_next_engagement_at_front(@engagements, @next_engagement)
    end
  end

  def update
    @availabilities = (Availability.find(params[:id])).engagement.availabilities
    availabilityCreator = AvailabilityCreator.new(availability_params, @availabilities)
    availabilityCreator.update_availabilities

    flash[:notice] = "Your availability was successfully updated."
    redirect_to profile_path
  end

  def dropdown_change
  end

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

  def put_next_engagement_at_front(engagements, next_engagement)
    swap_index = engagements.index(next_engagement)
    engagements[0], engagements[swap_index] = engagements[swap_index], engagements[0]
  end

  def current_availabilities
    if current_user.has_role?("student")
      current_user.student_account.engagements.first.availabilities
    else
      current_user.client_account.engagements.first.availabilities
    end
  end
end
