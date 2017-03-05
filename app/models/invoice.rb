class Invoice < ActiveRecord::Base
  # Associations
  belongs_to :tutor, class_name: "User", foreign_key: "tutor_id"
  belongs_to :student, class_name: "User", foreign_key: "student_id"
  belongs_to :assignment
  before_save :set_amount_value

  validates :hours, presence: true, numericality: { greater_than_or_equal_to: 1 }

  private

  def set_amount_value
    self.amount = hourly_rate.to_f * hours
  end
end
