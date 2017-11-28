class StudentAccount < ApplicationRecord
  belongs_to :user
  belongs_to :client_account
  has_many :engagements
  validates_presence_of :client_account, :name

  def email
    user ? user.email : client.email
  end

  def client
    client_account.user
  end
end
