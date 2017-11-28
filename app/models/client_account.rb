class ClientAccount < ApplicationRecord
  belongs_to :user
  has_many :student_accounts
  has_many :engagements
end
