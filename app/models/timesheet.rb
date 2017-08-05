class Timesheet < ActiveRecord::Base
  belongs_to :user

  scope :pending, -> { where(status: 'pending') }

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

  def hours
    minutes.to_f / 60
  end

  def amount
    User.find(user_id).contract.hourly_rate * hours / 100
  end

  def amount_in_cents
    User.find(user_id).contract.hourly_rate * hours
  end

  def to_payment
    Payment.new(payment_params)
  end

  private

  def payment_params
    { amount_in_cents: amount_in_cents, payee_id: user_id,
      description: description }
  end
end
