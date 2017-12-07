class StudentAccount < ApplicationRecord
  belongs_to :user
  belongs_to :client_account
  has_many :engagements
  has_many :tutor_accounts, through: :engagements
  validates_presence_of :client_account, :name

  def email
    user ? user.email : client.email
  end

  def client
    client_account.user
  end

  def academic_types_engaged
    engagements.joins(:subject).pluck("subjects.academic_type").uniq
  end

  def tutors
    tutor_accounts.map(&:user)
  end
end
