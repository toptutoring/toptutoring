class TutorAccount < ApplicationRecord
  belongs_to :user
  has_many :engagements
  has_many :student_accounts, through: :engagements
  has_and_belongs_to_many :subjects
  has_one :contract, as: :account, dependent: :destroy

  validates_presence_of :user

  delegate :name, to: :user
end
