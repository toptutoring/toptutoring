class AvailabilityController < ApplicationController

  DAYS = %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday)

  def new
    @days = DAYS
    @availabilities = []
    7.times do
      @availabilities << Availability.new
    end

    @engagements = Engagement.where(client_id: current_user.id)
  end

  def create

    @days = DAYS
    @day_hash = [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]
    @availabilities = []

    @engagement = Engagement.find((params[:info][:current_engagement]).to_i)
    #STDOUT.puts("#{params[:info][:current_engagement]}")

    from_date_time = DateTime.new
    to_date_time = DateTime.new

    7.times do
      @availabilities << @engagement.availabilities.build(from: DateTime.new, to: DateTime.new)
    end

    @availabilities.each do |a|

      i = @availabilities.index(a)

      a.update_attribute(:from, a.from.beginning_of_week(start_day = @day_hash[i]))
      a.update_attribute(:to, a.to.beginning_of_week(start_day = @day_hash[i]))

      from_time_sched = (params[:info]["#{(@days[i])}_from"]+params[:info]["#{(@days[i])}_from_am_pm"]).to_time
      to_time_sched = (params[:info]["#{(@days[i])}_to"]+params[:info]["#{(@days[i])}_to_am_pm"]).to_time


      if !(from_time_sched.nil?)
        a.update_attribute(:from, a.from.change({hour: from_time_sched.hour, min: from_time_sched.min, sec: from_time_sched.sec}))
      end

      if !(to_time_sched.nil?)
        a.update_attribute(:to, a.to.change({hour: to_time_sched.hour, min: to_time_sched.min, sec: to_time_sched.sec}))
      end

      if !a.save
        flash[:danger] = "There was an error in your submission."
        render 'new'
      end
    end

    flash[:notice] = "Your submission for (Engagement) was successful."
    redirect_to profile_path
  end

#
#
#  def availability_params
#
#    permit_strings = []
#
#    7.times do |count|
#      permit_strings << "#{DAYS[count]}_from"
#      permit_strings << "#{DAYS[count]}_to"
#      permit_strings << "#{DAYS[count]}_from_am_pm"
#      permit_strings << "#{DAYS[count]}_to_am_pm"
#    end
#
#    permit_strings = permit_strings.map &:to_sym
#    STDOUT.puts(permit_strings)
#
#    params.require(:info).permit(permit_strings)
#  end
end
