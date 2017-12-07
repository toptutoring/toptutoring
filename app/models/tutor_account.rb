class TutorAccount < ApplicationRecord
  belongs_to :user
  has_many :engagements
  has_many :student_accounts, through: :engagements
end
