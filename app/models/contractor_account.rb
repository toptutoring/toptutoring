class ContractorAccount < ApplicationRecord
  belongs_to :user
  has_one :contract, as: :account, dependent: :destroy
end
