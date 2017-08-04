class Invoice < ActiveRecord::Base
  # Associations
  belongs_to :tutor, class_name: "User", foreign_key: "tutor_id"
  belongs_to :client, class_name: "User", foreign_key: "client_id"
  belongs_to :engagement
  before_save :set_amount_value, :set_tutor_pay_cents
  validates :hours, numericality: { greater_than_or_equal_to: 0 }

  scope :pending, -> { where(status: 'pending') }

  def tutor_pay
    tutor_pay_cents.to_f / 100
  end

  scope :newest_first, -> { order("created_at DESC").limit(100) }

  private

  def set_amount_value
    self.amount = hourly_rate.to_f * hours
  end

  def set_tutor_pay_cents
    self.tutor_pay_cents = (hours * User.find(tutor_id).contract.hourly_rate).to_i
  end
end
