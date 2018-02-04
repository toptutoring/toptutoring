class ContractorAccount < ApplicationRecord
  belongs_to :user
  has_one :contract, as: :account, dependent: :destroy
  has_many :payouts, as: :receiving_account

  monetize :hourly_rate_cents

  validates_presence_of :user
end
