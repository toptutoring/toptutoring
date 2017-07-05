class Timesheet < ApplicationRecord
  belongs_to :users
  validate :hours_must_be_quarter_hours, :date_must_be_before_today

  def hours_must_be_quarter_hours
    hours_divided = hours.to_f * 4
    errors.add(:hours, "must be in quarter hours") unless hours_divided == hours_divided.to_i
  end

  def date_must_be_before_today
    errors.add(:date, "may not be in the future.") unless date.to_date <= Date.today.end_of_day
  end
end
