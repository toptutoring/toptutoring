class Payment < ActiveRecord::Base
  # Associations #
  belongs_to :payer, class_name: "User", foreign_key: "payer_id"
  belongs_to :approver, class_name: "User", foreign_key: "approver_id"

  # Validations #
  validates :amount_cents, numericality: { greater_than: 0 }
  validates_presence_of :payer_id

  # Monetize amounts
  monetize :amount_cents

  # Scopes #
  scope :from_user, ->(payer_id) { where(payer_id: payer_id) }
end
