class Payment < ActiveRecord::Base
  # Associations #
  belongs_to :payer, class_name: "User", foreign_key: "payer_id"
  belongs_to :payee, class_name: "User", foreign_key: "payee_id"
  before_validation :set_destination

  # Validations #
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validate :payee_validation
  validate :payer_validation

  # Scopes #
  scope :from_parents, -> { where.not(customer_id: nil) }
  scope :from_customer, ->(customer_id) { where(customer_id: customer_id) }
  scope :to_tutor, -> { where.not(destination: nil) }
  scope :from_user, ->(payer_id) { where(payer_id: payer_id) }

  def payee_validation
    if source && !payee_id
      errors.add(:payee_id, "can't be blank")
    end
  end

  def payer_validation
    if customer_id || source && !payer_id
      errors.add(:payer_id, "can't be blank")
    end
  end

  def set_destination
    if source
      self.destination = payee.auth_uid
    end
  end
end
