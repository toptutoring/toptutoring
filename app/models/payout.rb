class Payout < ApplicationRecord
  belongs_to :receiving_account, polymorphic: true
  belongs_to :approver, class_name: "User", foreign_key: "approver_id"
  validates :amount_cents, numericality: { greater_than: 0 }

  scope :contractors, -> { where(receiving_account_type: "ContractorAccount") }
  scope :tutors, -> { where(receiving_account_type: "TutorAccount") }

  monetize :amount_cents

  def payee
    receiving_account.user
  end
end
