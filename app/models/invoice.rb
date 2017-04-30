class Invoice < ActiveRecord::Base
  # Associations
  belongs_to :tutor, class_name: "User", foreign_key: "tutor_id"
  belongs_to :student, class_name: "User", foreign_key: "student_id"
  belongs_to :engagement
  before_save :set_amount_value

  enum status: [:pending, :paid, :cancelled]

  validates :hours, presence: true

  private

  def set_amount_value
    self.amount = hourly_rate.to_f * hours
  end
end
