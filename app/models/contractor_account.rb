class ContractorAccount < ApplicationRecord
  belongs_to :user
  has_one :contract, as: :account, dependent: :destroy
  has_many :payouts, as: :receiving_account

  validates_presence_of :user
end
