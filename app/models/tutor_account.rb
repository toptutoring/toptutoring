class TutorAccount < ApplicationRecord
  belongs_to :user
  has_many :engagements
  has_many :student_accounts, through: :engagements
  has_and_belongs_to_many :subjects
  has_one :contract

  validates_presence_of :user
end
