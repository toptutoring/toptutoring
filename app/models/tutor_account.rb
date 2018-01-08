class TutorAccount < ApplicationRecord
  belongs_to :user
  has_many :engagements
  has_many :student_accounts, through: :engagements
  has_and_belongs_to_many :subjects
  has_one :contract, as: :account, dependent: :destroy
  has_many :payouts, as: :receiving_account

  validates_presence_of :user

  # clears join table
  before_destroy { subjects.clear }

  delegate :name, to: :user
end
