class Invoice < ActiveRecord::Base
  # Associations
  belongs_to :tutor, class_name: "User", foreign_key: "tutor_id"
  belongs_to :client, class_name: "User", foreign_key: "client_id"
  belongs_to :engagement
  before_save :set_amount_value

  enum status: [:pending, :paid, :cancelled]

  scope :newest_first, -> { order("created_at DESC").limit(100) }

  private

  def set_amount_value
    self.amount = hourly_rate.to_f * hours
  end
end
