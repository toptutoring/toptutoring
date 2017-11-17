class Payment < ActiveRecord::Base
  # Associations #
  belongs_to :payer, class_name: "User", foreign_key: "payer_id"
  belongs_to :payee, class_name: "User", foreign_key: "payee_id"
  belongs_to :approver, class_name: "User", foreign_key: "approver_id"
  before_validation :set_destination

  # Validations #
  validates :amount_cents, numericality: { greater_than: 0 }
  validate :payee_validation, :payer_validation

  # Monetize amounts
  monetize :amount_cents

  # Scopes #
  scope :from_clients, -> { where.not(customer_id: nil) }
  scope :to_tutor, -> { where.not(destination: nil) }
  scope :from_user, ->(payer_id) { where(payer_id: payer_id) }

  def payee_validation
    if source && !payee_id
      errors.add(:payee_id, "can't be blank")
    end
  end

  def payer_validation
    if (customer_id || source)  && !payer_id
      errors.add(:payer_id, "can't be blank")
    end
  end

  def set_destination
    if source
      self.destination = payee.auth_uid
    end
  end
end
