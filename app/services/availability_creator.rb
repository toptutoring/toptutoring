class AvailabilityCreator

  DAYS = %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday)
  DAYS_IN_A_WEEK = 7

  def initialize(params, availabilities)
    @params = params
    @availabilities = availabilities
    @engagement = @engagement = Engagement.find((params[:current_engagement]).to_i)
    @days = DAYS
    @day_hash = [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]
  end

  def create_availabilities

    populate_engagement_with_new_availabilities

    @availabilities.each do |availability|

      current_availability_index = @availabilities.index(availability)
      set_availability_week_day(availability, current_availability_index)
      set_availability_time_interval(availability, current_availability_index)

      if !availability.save
        flash[:danger] = "There was an error in your submission."
        render 'new'
      end
    end

  end

  def update_availabilities

    @availabilities.each do |availability|

      current_availability_index = @availabilities.index(availability)
      set_availability_week_day(availability, current_availability_index)
      set_availability_time_interval(availability, current_availability_index)

      if !availability.save
        flash[:danger] = "There was an error in your submission."
        render 'new'
      end
    end

  end

  private

  def populate_engagement_with_new_availabilities
    DAYS_IN_A_WEEK.times do
      @availabilities << @engagement.availabilities.build(from: DateTime.new, to: DateTime.new)
    end
  end

  def set_availability_week_day(availability, index)
    availability.update_attribute(:from, availability.from.beginning_of_week(start_day = @day_hash[index]))
    availability.update_attribute(:to, availability.to.beginning_of_week(start_day = @day_hash[index]))
  end


  def set_availability_week_day(availability, index)
    availability.update_attribute(:from, availability.from.beginning_of_week(start_day = @day_hash[index]))
    availability.update_attribute(:to, availability.to.beginning_of_week(start_day = @day_hash[index]))
  end

  def set_availability_time_interval(availability, index)

    from_time_numbers_string = @params["#{(@days[index])}_from"]
    from_time_period_string = @params["#{(@days[index])}_from_am_pm"]
    to_time_numbers_string = @params["#{(@days[index])}_to"]
    to_time_period_string = @params["#{(@days[index])}_to_am_pm"]

    #from_time_numbers_string+from_time_period_string = "1:00+am"
    from_time_sched = (from_time_numbers_string+from_time_period_string).to_time
    to_time_sched = (to_time_numbers_string+to_time_period_string).to_time


    if !(from_time_sched.nil?)
      availability.update_attribute(:from, availability.from.change({hour: from_time_sched.hour, min: from_time_sched.min, sec: from_time_sched.sec}))
    end

    if !(to_time_sched.nil?)
      availability.update_attribute(:to, availability.to.change({hour: to_time_sched.hour, min: to_time_sched.min, sec: to_time_sched.sec}))
    end
  end
end
