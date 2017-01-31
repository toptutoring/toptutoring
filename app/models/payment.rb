class Payment < ActiveRecord::Base
  # Associations #
  belongs_to :payer, class_name: "User", foreign_key: "payer_id"
  belongs_to :payee, class_name: "User", foreign_key: "payee_id"
  before_validation :set_destination

  # Validations #
  validates_presence_of :payer_id
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validate :payee_validation

  # Scopes #
  scope :from_parents, -> { where.not(customer_id: nil) }
  scope :from_customer, ->(customer_id) { where(customer_id: customer_id) }

  def payee_validation
    if source && !payee_id
      errors.add(:payee_id, "can't be blank")
    end
  end

  def set_destination
    if source
      self.destination = payee.auth_uid
    end
  end
end
