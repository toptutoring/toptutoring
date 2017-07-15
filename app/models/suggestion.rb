class Suggestion < ActiveRecord::Base
  # Associations
  belongs_to :engagement

  # Validations
  validate :suggested_minutes_must_be_quarter_hours, :suggested_minutes_must_be_greater_than_zero
  validates :suggested_minutes, numericality: { only_integer: true }

  def suggested_minutes_must_be_quarter_hours
    return if (suggested_minutes % 15).zero?
    errors.add(:suggested_hours, "must be in quarter hours")
  end

  def suggested_minutes_must_be_greater_than_zero
    return if suggested_minutes > 0
    errors.add(:suggested_hours, "must be greater than 0")
  end

  def hours
    suggested_minutes.to_f / 60
  end
end
