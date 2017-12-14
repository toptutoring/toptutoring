class Invoice < ActiveRecord::Base
  # Associations
  belongs_to :submitter, class_name: "User", foreign_key: "submitter_id"
  belongs_to :client, class_name: "User", foreign_key: "client_id"
  belongs_to :engagement
  validates :hours, numericality: { greater_than_or_equal_to: 0 }
  validates_presence_of :submitter_id, :description,
                        :hours, :submitter_type
  with_options if: :by_tutor? do |invoice|
    invoice.validates_presence_of :client_id, :engagement_id, :subject,
                                  :hourly_rate_cents, :amount_cents
  end

  scope :pending, -> { where(status: "pending") }
  scope :not_pending, -> { where.not(status: "pending").order(:status) }
  scope :newest_first, -> { order("created_at DESC").limit(100) }

  enum submitter_type: [:by_tutor, :by_contractor]

  # Monetize hourly_rate, amount, and tutor pay
  monetize :hourly_rate_cents, numericality: { greater_than: 0 }, allow_nil: true
  monetize :amount_cents, allow_nil: true
  monetize :submitter_pay_cents, presence: true

  def self.contractor_pending_total
    Money.new(by_contractor.pending.sum(:submitter_pay_cents))
  end

  def self.tutor_pending_total
    Money.new(by_tutor.pending.sum(:submitter_pay_cents))
  end
end
