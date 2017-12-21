class ContractorAccount < ApplicationRecord
  belongs_to :user
  has_one :contract, as: :account, dependent: :destroy

  validates_presence_of :user
end
