class StudentAccount < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :client_account
  has_many :engagements, dependent: :destroy
  has_many :tutor_accounts, through: :engagements
  validates_presence_of :client_account, :name

  def email
    user ? user.email : "No email provided"
  end

  def client
    client_account.user
  end

  def academic_types_engaged
    engagements.joins(:subject).pluck("subjects.academic_type").uniq
  end

  def tutors
    User.joins(:tutor_account).where(tutor_accounts: { id: tutor_accounts.ids })
  end
end
