class Payment < ActiveRecord::Base
  belongs_to :payer, class_name: "User", foreign_key: "payer_id"
  belongs_to :payee, class_name: "User", foreign_key: "payee_id"

  scope :from_parents, -> { where.not(customer_id: nil) }
  scope :from_customer, ->(customer_id) { where(customer_id: customer_id) }
end
