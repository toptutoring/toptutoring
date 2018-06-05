class ClientAccount < ApplicationRecord
  belongs_to :user
  has_many :student_accounts, dependent: :destroy
  has_many :engagements, dependent: :destroy
  has_many :invoices, through: :engagements
  has_one :client_review
  validates_presence_of :user

  def academic_types_engaged
    types = []
    types << "online_academic" if user.online_academic_rate > 0
    types << "online_test_prep" if user.online_test_prep_rate > 0
    types << "in_person_academic" if user.in_person_academic_rate > 0
    types << "in_person_test_prep" if user.in_person_test_prep_rate > 0
    types
  end

  def highest_rate_type
    return nil if academic_types_engaged.empty?
    academic_types_engaged.sort_by { |type| user.send(type + "_rate") }.last
  end

  def send_review_email?
    !review_requested && request_review?
  end

  def request_review?
    return false if client_review
    invoices.count >= 3 && invoices.five_star.any?
  end
end
