class StudentAccount < ApplicationRecord
  belongs_to :user
  belongs_to :client_account
  has_many :engagements
  has_many :tutor_accounts, -> { where.not(engagements: { state: "archived" }) }, through: :engagements
  validates_presence_of :client_account, :name

  def email
    user ? user.email : "No email provided"
  end

  def client
    client_account.user
  end

  def tutors
    User.joins(:tutor_account).where(tutor_accounts: { id: tutor_accounts.ids })
  end
end
