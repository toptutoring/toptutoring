class StudentAccount < ApplicationRecord
  belongs_to :user
  belongs_to :client, class_name: "User", foreign_key: :client_id
  validates_presence_of :client_id, :name

  def email
    user ? user.email : client.email
  end
end
