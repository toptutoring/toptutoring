class ClientAccount < ApplicationRecord
  belongs_to :user
  has_many :student_accounts
  has_many :engagements
  has_many :suggestions, through: :engagements
  validates_presence_of :user

  def academic_types_engaged
    engagements.joins(:subject).pluck("subjects.academic_type").uniq
  end
end
