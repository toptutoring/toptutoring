class Invoice < ActiveRecord::Base
  # Associations
  belongs_to :tutor, class_name: "User", foreign_key: "tutor_id"
  belongs_to :assignment
  before_save :set_amount_value

  private

  def set_amount_value
    self.amount = hourly_rate.to_f * hours
  end
end
