class Invoice < ActiveRecord::Base
  # Associations
  belongs_to :tutor, class_name: "User", foreign_key: "tutor_id"
  belongs_to :client, class_name: "User", foreign_key: "client_id"
  belongs_to :engagement
  validates_presence_of :client_id, :tutor_id
  validates :hours, numericality: { greater_than_or_equal_to: 0 }
  validates_presence_of :tutor_id, :client_id, :description,
                        :subject, :hours

  scope :pending, -> { where(status: 'pending') }
  scope :newest_first, -> { order("created_at DESC").limit(100) }

  # Monetize hourly_rate, amount, and tutor pay
  monetize :hourly_rate_cents, numericality: { greater_than: 0 }
  monetize :amount_cents, presence: true
  monetize :tutor_pay_cents, presence: true

  def to_payment
    Payment.new(payment_params)
  end

  private

  def payment_params
    { amount: tutor_pay, payee_id: tutor_id,
      description: description }
  end
end
