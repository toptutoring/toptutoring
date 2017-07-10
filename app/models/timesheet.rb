class Timesheet < ApplicationRecord
  belongs_to :users
  validate :minutes_must_be_quarter_hours, :date_must_be_before_today,
           :minutes_must_be_greater_or_equal_to_one
  validates :minutes, numericality: { only_integer: true }

  def minutes_must_be_quarter_hours
    errors.add(:hours, "must be in quarter hours") unless (minutes % 15).zero?
  end

  def minutes_must_be_greater_or_equal_to_one
    errors.add(:hours, "must be greater or equal to 1") unless minutes >= 1
  end

  def date_must_be_before_today
    input_date = date.to_date
    today = Date.today.end_of_day
    return unless input_date >= today
    date_string = today.strftime("%-m/%-e/%y")
    errors.add(:date, "must be on or before #{date_string}")
  end
end
